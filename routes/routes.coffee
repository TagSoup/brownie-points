foursq = require("../conf/foursquare")

routes = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', { title: "Fancy" }

  app.get '/foursq', (req, res) ->
    res.send 'foursquare test'

module.exports = routes
