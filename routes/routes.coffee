
routes = (app) ->

  app.get '/', (req, res) ->
    res.render 'index', { title: "Fancy" }

module.exports = routes