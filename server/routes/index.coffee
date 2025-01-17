db = require("../database.coffee")
_ = require('underscore')

exports.index = (req, res) -> 
  res.render('index', { title: 'Express' })


exports.rounds = {}
exports.rounds.all = (req, res) -> 

  db.rounds.find( (err, rounds) ->
    if(err)
      return
    res.json(rounds)
    )

exports.rounds.one = (req, res) -> 
  roundID = db.ObjectId(req.params.id)

  db.rounds.findOne({"_id": roundID }, (err, round) ->
    if(err)
      return
    res.json(round)
    )

exports.rounds.create = (req, res) ->
  params = req.params
  if params.duration < 1
    res.json(400, {
      "error": "Cannot have a negative or 0 round duration."
    })
    return
  if params.maxUsers < 2
    res.json(400, {
      "error": "Round must have at least two users"
    })
    return
  else
    round = {
      roundName: params.roundName,
      maxUsers: parseInt(params.maxUsers),
      duration: parseInt(params.duration),
      timeStart: (new Date()).valueOf()
      users: []
    }
    db.rounds.find(
      { roundName: round.roundName},
      (err, rounds) ->
        if(err)
          return
        if(rounds.length)
          for roundItr in rounds
            if roundIsActive(roundItr)
              res.send("Active round exists with name #{roundItr.roundName}")
              return
              
        db.rounds.save(round)
        db.rounds.findOne({roundName: round.roundName, duration: round.duration}, (err, returnedRound) ->
          
          res.json(200, returnedRound)
          )
    )

exports.rounds.highestScoringUser = (json, socket) ->

  roundID = json.roundID
  markerID = json.markerID
  db.rounds.findOne({"_id": db.ObjectId(roundID)}, (err, round) ->
    user = null
    console.log(round)
    user = u for u in round.users when user is null or u.score > user.score
    socket.broadcast.emit('sendHighestScoringUser', user)
    username = null
    username = u.name for u in round.users when parseInt(u.markerID) is parseInt(markerID)
    newJSON = {
        roundID: roundID
        username: username
      }
      console.log(newJSON)
    socket.broadcast.emit('rumble', newJSON)
  )

exports.rounds.newRoundCreated = (socket) ->
  db.rounds.find( (err,rounds) ->
    socket.broadcast.emit('allRounds', rounds)
  )


exports.rounds.register = (req, res) ->
  params = req.params
  roundID = db.ObjectId(params.roundID)
  db.rounds.findOne({"_id" : roundID }, (err, round) ->
    if (err)
      return
    userNames = (user.name for user in round.users)
    if _.contains(userNames, params.userName)
      res.send(400, "The username #{params.userName} is already taken for this round.")
    else if (userNames.length == round.maxUsers)
      res.send(400, "This round is full.")
    else
      db.rounds.update({"_id" : roundID }, {
        $push: { users: {
          name:params.userName,
          score:0,
          markerID: parseInt(params.markerID)
          $sort: { score: -1 }
        }}
      })
      db.rounds.findOne({"_id":roundID}, (err, json) ->
        res.send(json))
    )

exports.rounds.leave = (req, res) ->
  params = req.params
  roundID = db.ObjectId(params.roundID)
  db.rounds.update({"_id":roundID},
    {
      $pull: {
        users: { name: params.userName }
      }
    }
    )
  res.send('ok?')

exports.activeRounds = {}
exports.activeRounds.one = (req, res) ->
  params = req.params
  db.rounds.find({ roundName: params.roundName }, (err, rounds) ->
    if(err)
      return
    if(rounds.length)
      for roundItr in rounds
        if roundIsActive(roundItr)
          res.json(roundItr)
          return
    res.send("Active round with name #{params.roundName} not found")
    )
exports.activeRounds.all = (req, res) ->
  db.rounds.find( (err, rounds) ->
    rounds = (round for round in rounds when roundIsActive(round))
    res.json(rounds)
    )
exports.activeRounds.alljson = (callback) ->
  db.rounds.find( (err, rounds) ->
    rounds = (round for round in rounds when roundIsActive(round))
    callback(rounds)
    )

roundIsActive = (round) ->
  now = new Date()
  return round.timeStart < now.valueOf() and round.timeStart + round.duration > now.valueOf()


exports.shoot = (req, res) ->
  params = req.params
  roundId = params.roundId
  username = params.userName

  unless (roundId and username)
    res.send("Need roundId and Username")
  else
    db.rounds.findOne({ "_id": db.ObjectId(roundId) }, (err, round) ->
      if (err)
        return
      res.send(200)
      user.score += 100 for user in round.users when user.name is username
      db.rounds.save(round)
    )
