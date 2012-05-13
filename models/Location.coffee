crypto = require 'crypto'
mongoose = require 'mongoose'
mongooseTypes = require 'mongoose-types'

Schema = mongoose.Schema
schemaOptions = 
  strict: true

###
  Location ratings
###
LocationRating = new Schema
  rating:
    type: Number
    enum: [ 1, 2, 3, 4, 5 ]
    required: true
  active:
    type: Boolean
    default: true
  , schemaOptions

LocationRating.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

###
  Location comments
###
LocationComment = new Schema
  comment: String
  active:
    type: Boolean
    default: true
  , schemaOptions

LocationComment.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

LocationComment.path('comment').set (str) -> #trim to 140 characters
  str.substr 0,140

###
  Location images
###
LocationImage = new Schema
  path: String
  active:
    type: Boolean
    default: true
  , schemaOptions

LocationImage.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

###
  Location info
###
Location = new Schema
  name: 
    type: String
    required: true
  lat:
    type: Number
    required: true
  lng:
    type: Number
    required: true
  ratings: [ LocationRating ]
  rating: Number
  foursquareId: String
  address: String
  photos: [ LocationImage ]
  comments: [ LocationComment ]
  #4sq identifier?
  , schemaOptions

Location.pre 'save', (next) ->
  #every time we save, update the rating
  sum = 0
  @ratings.forEach (rate) ->
    sum += rate.rating
  @rating = sum / @ratings.length
  console.log 'location rating', @rating
  next()

Location.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

module.exports = mongoose.model 'Location', Location