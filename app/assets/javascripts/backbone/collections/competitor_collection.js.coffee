define (require, exports, module) ->

  Backbone        = require 'backbone'
  CompetitorModel = require 'backbone/models/competitor_model'
  _               = require 'underscore'

  class CompetitorCollection extends Backbone.Collection
    model: CompetitorModel