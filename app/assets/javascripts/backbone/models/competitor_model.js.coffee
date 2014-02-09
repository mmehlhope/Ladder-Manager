define (require, exports, module) ->

  Backbone = require 'backbone'

  class CompetitorModel extends Backbone.Model
    urlRoot: '/competitors'