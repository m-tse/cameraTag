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

exports.rounds.create = (req, res) ->
  params = req.params
  if params.duration < 1
    res.send("Cannot have a negative or 0 round duration.")
    return
  if params.maxUsers < 2
    res.send("Round must have at least two users")
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
          
          res.json(returnedRound)
          )
    )

exports.rounds.register = (req, res) ->
  params = req.params
  roundID = db.ObjectId(params.roundID)
  db.rounds.findOne({"_id" : roundID }, (err, round) ->
    if (err)
      return
    userNames = (user.name for user in round.users)
    if _.contains(userNames, params.userName)
      res.send("The username #{params.userName} is already taken for this round.")
    if (userNames.length == round.maxUsers)
      res.send("This round is full.")
    else
      db.rounds.update({"_id" : roundID }, { $push: { users: {name:params.userName, score:0}}})
      db.rounds.findOne({"_id":roundID}, (err, json) ->
        res.send(json))
    )

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
  params = req.params
  db.rounds.find( (err, rounds) ->
    rounds = (round for round in rounds when roundIsActive(round))
    res.json(rounds)
    )

roundIsActive = (round) ->
  now = new Date()
  return round.timeStart < now.valueOf() and round.timeStart + round.duration > now.valueOf()


exports.shoot = (req, res) ->
  params = req.params
  roundId = params.roundId
  username = params.userName

  console.log("hello")
  unless (roundId and username)
    res.send("Need roundId and Username")
  else
    console.log("hello again")
    db.rounds.findOne({ "_id": db.ObjectId(roundId) }, (err, round) ->
      if (err)
        return
      res.send(200)
      user.score += 100 for user in round.users when user.name is username
      db.rounds.save(round)
    )
