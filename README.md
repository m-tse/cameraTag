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
- round/create(numUsers, roundName) -> Check roundName is unique
- shoot(roundID, ownName, targetMarkerID)
- rounds() -> rounds[] { roundName: String, numMaxContestants: int, numCurrentContestants: int, contestantNames: string[], timeStart: date}
- enterRound(ownName, roundName) -> Check that ownNAme is unique

## Game Logic:
1. Create a round
2. Round will automatically start in 30 seconds

## Schema Database:
```
Round:{
  roundName: String,
  duration: int,
  timeStart: int,
  users [
    {userName: String}
  ]
```

## Future Features:
- User Accounts
- User stats (# wins, accuracy, etc.)
- Stock instead of time limit
- powerups (reflective shield, etc.)
- GPS coordinates, traps
- Capture The Flag

