define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Ladder_t          = require 'templates/ladders/ladder_t'
  MessageModel      = require 'backbone/models/message_model'
  MessagesView      = require 'backbone/views/widgets/messages_view'

  class LadderView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'click [data-action="delete-ladder"]'     : 'deleteLadder'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      this

    render: () ->
      @$el.html(Ladder_t(ladder: @model, _view: @))
      @messageCenter = new MessagesView(el: @$('.messaging'))
      this

    deleteLadder: (e) ->
      e.preventDefault() if e

      if confirm("Are you sure you want to delete #{@model.get('name')}? This will permanently delete all matches and competitors that belong to this ladder.")
        @model.destroy(
          success: () =>
            @removeEl()
          error: (existingModel, response) =>
            @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
        )
      else
        false

      this

    removeEl: () ->
      @$el.slideUp(() =>
        @remove()
      )
      this
