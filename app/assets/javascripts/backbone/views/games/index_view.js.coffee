define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Backbone         = require 'backbone'
  GameView         = require 'backbone/views/games/game_view'
  NewGameView      = require 'backbone/views/games/new_view'
  Games_t          = require 'templates/games/index_t'

  class GameCollectionView extends Backbone.View

    initialize: (options) ->
      @options = options
      @listenTo(@collection, 'add', @addOne)
      @listenTo(@collection, 'showNewGameForm', @showNewGameFrom)
      this

    render: () ->
      @addChildren()

      @$el.attr('id', 'games-for-match-' + @collection.match_id)
          .empty().html(Games_t(comp_1_name: @options.comp_1_name, comp_2_name: @options.comp_2_name))
      @$('tbody').append(@children)
      this

    addChildren: () ->
      @children = []
      _(@collection.models).each((model, index) =>
        # Increment number for the number of game, temporarily.
        model.set('number', index+1)
        gameView = new GameView(model: model)
        @children.push(gameView.render().el)
      )
      this

    addOne: (model) ->
      gameView     = new GameView(model: model)
      @$('tbody').append(gameView.render().el)
      this

    showNewGameForm: () ->
      gameView = new NewGameView()
      @$('tbody').append(gameView.render().el)
      this

    updateCollection: () ->
      @collection.fetch()
      this