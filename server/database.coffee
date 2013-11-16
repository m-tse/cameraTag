dbUrl = "CameraTag"
collections = ["rounds"]
db = require("mongojs").connect(dbUrl, collections)

module.exports = db