dbUrl = "CameraTag"
collections = ["rounds", "users"]
db = require("mongojs").connect(dbUrl, collections)

module.exports = db
