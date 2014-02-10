define (require, exports, module) ->

  Backbone = require 'backbone'

  class GameModel extends Backbone.Model

    urlRoot: '/games'