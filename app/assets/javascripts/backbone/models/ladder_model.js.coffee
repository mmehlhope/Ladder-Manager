define (require, exports, module) ->

  Backbone = require 'backbone'

  class LadderModel extends Backbone.Model

    urlRoot: '/ladders'