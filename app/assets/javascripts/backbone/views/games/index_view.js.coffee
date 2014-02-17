define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Backbone         = require 'backbone'
  GameView         = require 'backbone/views/games/game_view'
  NewGameView      = require 'backbone/views/games/new_view'
  Games_t          = require 'templates/games/index_t'

  class GameCollectionView extends Backbone.View

    className: 'games-table-wrapper collapse'

    initialize: () ->
      @listenTo(@collection, 'add', @showNewGameForm)
      # @listenTo(@collection, 'sync', @showNewGameForm)
      this

    render: () ->
      @addChildren()

      @$el.attr('id', 'games-for-match-' + @collection.match_id)
          .empty().html(Games_t())
      @$('tbody').append(@children)
      this

    addChildren: () ->
      @children = []
      _(@collection.models).each((model, index) =>
        gameView = new GameView(model: model, attributes: {'number': index+1})
        @children.push(gameView.render().el)
      )
      this

    showNewGameForm: (newGame) ->
      gameView = new NewGameView(model: newGame)
      @listenTo(gameView, 'newGameCreated', @updateCollection)
      @$('tbody').append(gameView.render().el)
      this

    updateCollection: () ->
      @collection.fetch()
      this