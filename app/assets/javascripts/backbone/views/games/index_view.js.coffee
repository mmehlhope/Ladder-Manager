define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Backbone         = require 'backbone'
  GameView         = require 'backbone/views/games/game_view'
  NewGameView      = require 'backbone/views/games/new_view'
  Games_t          = require 'templates/games/index_t'

  class GameCollectionView extends Backbone.View

    className: 'games-table-wrapper collapse'

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
        model.set('number', index+1)
        gameView = new GameView(model: model)
        @children.push(gameView.render().el)
      )
      this

    addOne: (model) ->
      gameView     = new GameView(model: model)
      @$('tbody').append(gameView.render().el)
      # Post success message of new match
      # @messageCenter.post(
      #   "You've added a new match between #{model.get('competitor_1').name} and #{model.get('competitor_2').name}!",
      #   'success'
      # )
      this


    showNewGameForm: () ->
      gameView = new NewGameView()
      @listenTo(gameView, 'newGameCreated', @updateCollection)
      @$('tbody').append(gameView.render().el)
      this

    updateCollection: () ->
      @collection.fetch()
      this