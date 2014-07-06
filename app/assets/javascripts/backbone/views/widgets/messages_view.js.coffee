define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Backbone          = require 'backbone'
  MessageCollection = require 'backbone/collections/message_collection'
  MessageModel      = require 'backbone/models/message_model'
  MessageView       = require 'backbone/views/widgets/message_view'

  class MessagesView extends Backbone.View

    initialize: () ->
      @collection = new MessageCollection
      @listenTo(@collection, 'reset', @render)
      @listenTo(@collection, 'add', @render)
      this

    render: () ->
      @addChildren()
      @$el.empty().append(@children)
      this

    addChildren: () ->
      @children = []
      _(@collection.models).each((model) =>
        messageView = new MessageView(model: model)
        @children.push(messageView.render().el)
      )
      this

    post: (message, type, removeable=true) ->
      messageModel = new MessageModel(content: message, type: type, removeable: removeable)
      @collection.add(messageModel)
      this

    clear: () ->
      @collection.reset()
      this

    removeEl: () ->
      @remove()
      this

    # TODO: refactor
    startFadeTimer: () ->
      window.clearTimeout(@timer) if @timer
      @timer = setTimeout(() =>
        @$el.fadeOut(350, () =>
          @clear()
          @$el.removeAttr('style')
        )
      , 3000)
      this
