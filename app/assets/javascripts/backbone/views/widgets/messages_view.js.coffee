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
      @listenTo(@collection, 'destroy', @render)
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

    destroy: () ->
      @$el.remove()
      this
