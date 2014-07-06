define (require, exports, module) ->

  Backbone        = require 'backbone'
  MessageModel    = require 'backbone/models/message_model'

  class MessageCollection extends Backbone.Collection
    model: MessageModel
