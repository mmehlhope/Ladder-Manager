define (require, exports, module) ->

  Backbone   = require 'backbone'
  GameModel  = require 'backbone/models/game_model'

  class GameCollection extends Backbone.Collection
    model: GameModel
