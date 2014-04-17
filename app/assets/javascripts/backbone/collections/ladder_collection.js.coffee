define (require, exports, module) ->

  Backbone    = require 'backbone'
  LadderModel = require 'backbone/models/ladder_model'

  class LadderCollection extends Backbone.Collection
    model: LadderModel
