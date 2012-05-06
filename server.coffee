#exernal libraries to include
express = require("express")
#routes = require("./routes")
require "coffee-script"

#create server
app = module.exports = express.createServer()

#configuration
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require("stylus").middleware(src: __dirname + "/public")
  app.use app.router
  app.use express.static(__dirname + "/public")

###
  DEV
###
app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

###
  PROD
###
app.configure "production", ->
  app.use express.errorHandler()

require('./routes/routes') app
app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
