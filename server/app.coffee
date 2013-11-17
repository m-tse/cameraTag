

express = require('express')
routes = require('./routes')
# user = require('./routes/user')
http = require('http')
path = require('path')
_ = require('underscore')

app = express()


# all environments
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(app.router)
app.use(express.static(path.join(__dirname, 'public')))

# development only
# if ('development' == app.get('env')) 
  # app.use(express.errorHandler())

httpserver = http.createServer(app).listen(app.get('port'), ()->
  console.log('Express server listening on port ' + app.get('port'))
)
io = require('socket.io').listen(httpserver)

app.get('/rounds', routes.rounds.all)
app.get('/activeRounds/:roundName', routes.activeRounds.one)
app.get('/activeRounds', routes.activeRounds.all)
app.post('/rounds/create/:roundName/:maxUsers/:duration', routes.rounds.create)
app.post('/rounds/register/:userName/:roundID/:markerID', routes.rounds.register)
app.post('/shoot/:roundId/:userName/:targetMarkerId', routes.shoot)
app.post('/rounds/leave/:userName/:roundID', routes.rounds.leave)


io.sockets.on('connection', (socket) ->

  routes.activeRounds.alljson( (res) ->
    socket.emit('resetActiveRounds', res[0])
  )

  socket.on('shootSuccessful', (data) ->
    console.log("asdfasdfasdfasdfasdfas")
    json = JSON.parse(data)
    console.log(data)
    console.log(json)
    routes.rounds.highestScoringUser(json, socket)
  )

  socket.on('createRound', (data) ->
    console.log("allo")
    routes.rounds.newRoundCreated(socket)
  )
)
