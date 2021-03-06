middleware = require '../lib/middleware'
#require 'express-namespace'

Location = require('../models/Location')

module.exports = (app) ->

	app.namespace '/locations', ->

		app.get '/', (req, res, next) ->
			console.log 'wat'
			if not req.query.location #if you don't weigh in, you don't wrassle
				res.send 
					errors: 'You must include your location'
				, 400

			else #location is passed
				lnglat = req.query.location.split(',')
				search =
					location:
						'$near': lnglat
						'$maxDistance': 1 / 69 #within 1 mile
					
				if req.query.name
					search.name = new RegExp(req.query.name+'', 'i')

				if req.query.rating
					search.rating = $gte: req.query.rating

				console.log search
				Location.find search, (err, locs) ->
					if err
						console.trace err
						res.send 500
					else
						res.send locs

			
		app.get '/:id', (req, res, next) ->
			Location.findOne _id: req.params.id, (err, loc) ->
				if err
					console.log err
					res.send 500
				else if not loc
					res.send 404
				else
					res.send loc

			#location findOneId _id: xxx

		app.put '/:id', (req, res, next) ->
			Location.findOne _id: req.params.id, (err, loc) ->
				if err
					console.trace err
					res.send 500
				else if not loc
					res.send 404
				else
					loc.ratings.push
						rating: req.body.rating
						location: req.body.location.split(',')

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


		app.post '/', (req, res, next) ->
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
			if not req.body.location or not req.body.userLocation
				res.send "You must include the coords of the location and userLocation", 400
			else
				lnglat = req.body.location.split(',')
				req.body.location = lnglat
								
				loc = new Location req.body

				console.dir loc

				lnglat = req.body.userLocation.split(',')
				loc.ratings.push
					rating: req.body.rating
					location: lnglat
						
				#add comment if one exists
				if req.body.comment
					loc.comments.push 
						comment: req.body.comment

				#add image if one is passed
				if req.body.photo
					loc.photos.push 
						path: req.body.photo

				#save new location
				#TODO: check for and prevent duplicates
				loc.save (err) ->
					if err
						console.trace err
						res.send
							errors: middleware.errorHelper err, next
						, 400
						
					else
						res.send 
							location: loc
							path: '/locations/'+loc.id
