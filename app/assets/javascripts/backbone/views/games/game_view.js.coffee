define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Game_t            = require 'templates/games/game_t'
  BaseListItemView  = require 'backbone/views/common/base_list_item_view'
  MessagesView      = require 'backbone/views/widgets/messages_view'


  class GameView extends BaseListItemView

    tagName: 'tr'
    className: ''

    render: () ->
      @$el.html(Game_t(game: @model, _view: @))
      @messageCenter = new MessagesView(el: @$('.messaging'))
      @$('input:first').focus() if @inEditMode()
      this

    deleteItem: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete this game?")
        @model.destroy(
          success: () =>
            @removeEl()
          error: () =>
            @messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger', false)
            this
        )
      this