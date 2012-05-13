#exernal libraries to include
express = require "express"
require 'express-namespace'
#routes = require("./routes")
require "coffee-script"
mongoose = require 'mongoose'

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
  app.use express.logger()

###
  DEV
###
app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )
  app.set 'site-url', 'http://localhost:3000'
  mongoose.set 'debug', true

###
  PROD
###
app.configure "production", ->
  app.use express.errorHandler()
  app.set 'site-url', 'http://localhost:3000'

app.configure 'development', 'staging', 'production', ->
  #session
  hour = (60*60*1000)
  sessionLife = 7 * 24 * hour #7 day cookie
  app.set 'db-uri', require('./conf').db_uri
  ###app.use express.session
    secret: 'super secure'
    key: 'boutto.sid'
    store: new sessStore( url: app.set('db-uri')+'/sessions' )
    cookie:
      expires: new Date(Date.now() + sessionLife) #12 hour session
      maxAge: sessionLife #available for 1 hour###
  #global environment settings
  process.env.SITE_URL = app.set 'site-url'

#open db connection
db = mongoose.connect app.set 'db-uri'

require('./routes/routes') app
require('./routes/locations') app
app.listen 3000
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
