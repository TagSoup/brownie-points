crypto = require 'crypto'
mongoose = require 'mongoose'
mongooseTypes = require 'mongoose-types'

Schema = mongoose.Schema
SchemaOptions = 
  strict: true

###
  Location comments
###
LocationComment = new Schema
  comment: String
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
  name: String
  lat: String
  lng: String
  images: [ LocationImage ]
  comments: [ LocationComment ]
  rating:
    type: Number
    enum: [ 1, 2, 3, 4, 5 ]
  #4sq identifier?
  , schemaOptions

Location.plugin mongooseTypes.useTimestamps #append createdAt and modifiedAt
