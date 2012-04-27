crypto = require 'crypto'
mongoose = require 'mongoose'
mongooseTypes = require 'mongoose-types'

Schema = mongoose.Schema
SchemaOptions = 
  strict: true

###
  Location comments
###
LocationComments = new Schema
  comment: String
  , schemaOptions

LocationComments.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

LocationComments.path('comment').set (str) -> #trim to 140 characters
  str.substr 0,140

###
  Location images
###
LocationImage = new Schema
  path: String
  , schemaOptions

LocationImage.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt

###
  Location info
###
Location = new Schema
  name: String
  lat: String
  lng: String
  images: [ ] #collection of LocationImages
  rating: 
    type: Number
    enum: [ 1, 2, 3, 4, 5 ]
  #4sq identifier?
  , schemaOptions

Location.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt


