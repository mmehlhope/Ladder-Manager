define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Backbone         = require 'backbone'
  GameView         = require 'backbone/views/games/game_view'
  Games_t          = require 'templates/games/index_t'

  class GameCollectionView extends Backbone.View

    tagName: 'tr'

    initialize: () ->
      @children = []
      _(@collection.models).each((model) =>
        gameView = new GameView(model: model)
        @children.push(gameView.render().el)
      )
      @render()
      this

    render: () ->
      @$el.empty().append(Games_t())
      @$el.find('tbody').append(@children)
      this