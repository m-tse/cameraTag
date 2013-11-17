db = require("../database.coffee")

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
      maxUsers: params.maxUsers,
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
              
        res.json(round)
        db.rounds.save(round)
    )

exports.rounds.register = (req, res) ->
  params = req.params
  

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
