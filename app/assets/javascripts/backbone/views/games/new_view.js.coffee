define (require, exports, module) ->

  $            = require 'jquery'
  _            = require 'underscore'
  Util         = require 'util'
  Backbone     = require 'backbone'
  NewGame_t    = require 'templates/games/new_game_t'
  GameModel    = require 'backbone/models/game_model'
  MessagesView = require 'backbone/views/widgets/messages_view'
  BaseNewView  = require 'backbone/views/common/base_new_view'

  class NewGameView extends BaseNewView

    tagName: 'tr'
    className: ''
    list_item_model: GameModel
    template       : NewGame_t

    initialize: (options) ->
      @options = options
      this

    render: () ->
      @$el.html(@template(collection: @collection, comp_1_name: @options.comp_1_name, comp_2_name: @options.comp_2_name))
      @messagesView = new MessagesView(el: @$('.messaging'))
      this

    _successCallback: (jqXHR, textStatus) =>
      game = new GameModel(jqXHR)
      game.set('number', @collection.length+1)
      @removeEl(null, false)
      @collection.add(game)

    _errorCallback: (jqXHR, textStatus, errorThrown) =>
      @render()
      @messagesView.clear()
      @messagesView.post(Util.parseTransportErrors(jqXHR), 'danger', false)
      @$('input:first').focus()
      this
