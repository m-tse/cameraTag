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
  res.json(req.body)
  db.rounds.save(req.body)