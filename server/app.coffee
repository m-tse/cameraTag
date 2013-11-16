

express = require('express')
routes = require('./routes')
# user = require('./routes/user')
http = require('http')
path = require('path')

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


app.get('/', routes.index)
app.get('/rounds', routes.rounds.all)
# app.get('/activeRounds', routes.activeRounds.all)
app.get('/activeRounds/:roundName', routes.activeRounds.one)
app.get('/activeRounds', routes.activeRounds.all)
app.post('/rounds/create/:roundName/:maxUsers/:duration', routes.rounds.create)
app.post('/rounds/register/:userName/:roundName', routes.rounds.register)

http.createServer(app).listen(app.get('port'), ()->
  console.log('Express server listening on port ' + app.get('port'))
)
