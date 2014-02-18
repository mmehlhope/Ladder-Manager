define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Message_t  = require 'templates/widgets/message_t'

  class MessageView extends Backbone.View

    el: '.messaging'

    className: ''

    events:
      'click [data-action="close"]' : 'destroy'

    initialize: () ->
      @listenTo(@model, 'destroy', @delete)
      this

    render: () ->
      @$el.html(Message_t(message: @model))
      this

    deleteGame: (e) ->
      e.preventDefault()
      @model.destroy()
      this

    destroy: () ->
      @$el.remove()
      this
