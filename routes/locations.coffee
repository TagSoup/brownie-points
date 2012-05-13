middleware = require '../lib/middleware'
#require 'express-namespace'

Location = require('../models/Location')

module.exports = (app) ->

	app.namespace '/locations', ->

		app.get '/rating/:rating', (req, res, next) ->
			console.log 'rating: '+req.params.rating
			#return locations nearby matching >= rating
			if (req.params.rating not in [ 1, 2, 3, 4, 5])
				# not a rating, pass to :query:w
				next()

		app.get '/name/:query', (req, res, next) ->
			console.dir 'query: '+req.params.query
			# search 4sq
			# req.params.lat/lng
			next() #no match, show all nearby

		app.get '/', (req, res, next) ->
			console.log '/'
			res.send 404
			# pull 4sq
			# req.params.lat
			# res.params.lng

		app.get '/:id', (req, res, next) ->
			Location.findOne _id: req.params.id, (err, loc) ->
				if err
					console.log err
					res.send 500
				else if not loc
					res.send 404
				else
					obj = loc
					#obj['rating'] = loc.rating
					#obj['test'] = 'this is just a test'
					console.dir obj
					res.send obj

			#location findOneId _id: xxx

		app.post '/:id', (req, res, next) ->
			Location.findOne _id: req.params.id, (err, loc) ->
				if err
					console.log err
					res.send 500
				else if not loc
					res.send 404
				else
					loc.ratings.push
						rating: req.body.rating

					#add comment if one exists
					if req.body.comment
						loc.comments.push 
							comment: req.body.comment

					#add image if one is passed
					if req.body.photo
						loc.photos.push 
							path: req.body.photo

					loc.save (err) ->
						if err
							res.send
								errors: middleware.errorHelper err, next
							, 400
						else
							res.send
								location: loc
								path: '/locations/'+loc._id


		app.put '/', (req, res, next) ->
			# require name, location: lat: x, lng: y
			# optionally 4sq
			# EXAMPLE
			obj = #req.params.body
				name: '' #required
				rating: '1-5' #required
				coords: #required
					location: #location's location
						lat: 'x'
						lng: 'y'
					user: #user's current location
						lat: 'a'
						lng: 'b'
				foursquareId: '123'
				comment: ''
				photo: 'path'
				
			#instantiate new Location object using passed data
			loc = new Location req.body

			loc.ratings.push
				rating: req.body.rating

			#add comment if one exists
			if req.body.comment
				loc.comments.push 
					comment: req.body.comment

			#add image if one is passed
			if req.body.photo
				loc.photos.push 
					path: req.body.photo

			loc.save (err) ->
				if err
					res.send
						errors: middleware.errorHelper err, next
					, 400
					
				else
					res.send 
						location: loc
						path: '/locations/'+loc.id