require 'express-namespace'

module.exports = (app) ->

	app.namespace '/locations', ->

		app.get '/:rating', (res, res, next) ->
			#return locations nearby matching >= rating
			if (req.params.rating not in [ 1, 2, 3, 4, 5])
				# not a rating, pass to :query:w
				next()

		app.get '/:query', (req, res, next) ->
			# search 4sq
			# req.params.lat/lng
			next() #no match, show all nearby

		app.get '/', (req, res, next) ->
			# pull 4sq
			# req.params.lat
			# res.params.lng

		app.get '/:id', (req, res, next) ->
			#location findOneId _id: xxx

		app.post '/', (req, res, next) ->
			# require name, location: lat: x, lng: y
			# optionally 4sq
			obj = #req.params.body
				name: '' #required
				rating: '1-5' #required
				id: '' #e xiting record
				comment: ''
				photo: 'path'
				coords:
					location: #location's location
						lat: 'x'
						lng: 'y'
					user: #user's current location
						lat: 'a'
						lng: 'b'
				foursquareId: '123'



