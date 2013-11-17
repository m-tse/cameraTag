# Overview:
Laser Tag with your iPhone.  Install the app, register as a user.  Someone creates a round.  Enter the round and play.  Everyone wears a “QR” code and if you find someone in the viewfinder, take a snapshot of them to “shoot” them.

# Stack Implementation:
- Clientside Graphics Recognition, Poincloud API
- Clientside JS:Backbone.js
- Server MiddleWare: Express, Socket.io
- Server Backend: Node.js
- Database: Either mongoDB or Redis
- Hosting: Amazon EC2

## Node.js REST api:
- POST /rounds/create/:roundName/:maxUsers/:duration -> create a round with a name and number of users
- POST /shoot/:roundID/:ownName/:targetMarkerID -> shoot a target
- GET /rounds -> returns JSON of all the rounds
- GET /rounds/:id -> returns single round based on ID
- GET /activeRounds/:roundName -> returns active rounds with roundName
- GET /activeRounds/ -> returns all active rounds
- POST /rounds/register/:userName/:roundID/:markerID
- POST /rounds/leave/:userName/:roundID

## Game Logic:
1. Create a round
2. Round will automatically start in 30 seconds

## Schema Database:
```
Round:{
  roundName: String,
  duration: int,
  timeStart: int,
  maxUsers: int,
  users [
    {
      userName: String,
      markerID: int,
      score: int
    }
  ]
```

## Future Features:
- User Accounts
- User stats (# wins, accuracy, etc.)
- Stock instead of time limit
- powerups (reflective shield, etc.)
- GPS coordinates, traps
- Capture The Flag

