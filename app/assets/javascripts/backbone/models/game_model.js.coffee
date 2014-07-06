define (require, exports, module) ->

  Backbone = require 'backbone'

  class GameModel extends Backbone.Model

    defaults:
      competitor_1_score: 0
      competitor_2_score: 0
      winner_id: null
      match_id: null

    urlRoot: '/games'

    can_edit: () ->
      @get('can_edit')
