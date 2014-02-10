define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Game_t    = require 'templates/games/game_t'

  class GameView extends Backbone.View

    tagName: 'tr'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      this

    render: () ->
      @$el.append(Game_t(game: @model))
      this