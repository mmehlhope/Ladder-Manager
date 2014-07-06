define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Message_t  = require 'templates/widgets/message_t'

  class MessageView extends Backbone.View

    events:
      'click [data-action="close"]' : 'deleteMessage'

    initialize: () ->
      @listenTo(@model, 'destroy', @removeEl)
      this

    render: () ->
      @setElement(Message_t(message: @model))
      this

    deleteMessage: (e) ->
      e.preventDefault()
      @model.destroy()
      this

    removeEl: () ->
      @remove()
