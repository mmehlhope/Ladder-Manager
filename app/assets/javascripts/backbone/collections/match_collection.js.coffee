define (require, exports, module) ->

  Backbone   = require 'backbone'
  MatchModel = require 'backbone/models/match_model'

  class MatchCollection extends Backbone.Collection
    model: MatchModel
    url: '/matches'