fconf = require("../conf/foursquare")
foursq = require('node-foursquare')(fconf)


routes = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', { title: "Fancy" }

  ###
    example foursquare consumption
  ###

  #search to locations via querystring (ie name)
  app.get '/foursq/:query', (req, res, next) ->
    # roughly dos gringos in tempe
    lat = '33.497'
    lng = '-111.927'
    options = 
      intent: 'checkin'
      query: req.params.query
    foursq.Venues.search lat, lng, options, '', (err, results) ->
      console.log 'calling something'
      if err
        res.send err
      else
        res.send results

  #show all locations nearby
  app.get '/foursq', (req, res, next) ->
    # roughly dos gringos in tempe
    lat = '33.497'
    lng = '-111.927'
    options = 
      intent: 'checkin'
      limit: 25
    foursq.Venues.search lat, lng, options, '', (err, results) ->
      console.log 'calling something'
      if err
        res.send err
      else
        res.send results

  ###
    end example foursquare consumption
  ###

module.exports = routes
