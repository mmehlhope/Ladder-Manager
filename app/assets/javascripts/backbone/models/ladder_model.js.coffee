define (require, exports, module) ->

  Backbone = require 'backbone'

  class LadderModel extends Backbone.Model

    urlRoot: '/ladders'

    can_edit: () ->
      @get('can_edit')
