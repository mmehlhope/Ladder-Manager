define (require, exports, module) ->

  Backbone = require 'backbone'

  class MatchModel extends Backbone.Model

    urlRoot: '/matches'

    isFinalized: () ->
      @get('finalized')

    has_games: () ->
      @get('games').length > 0

    competitor_1_is_winner: () ->
      @get('competitor_1') == @get('winner_id')

    competitor_2_is_winner: () ->
      @get('competitor_2') == @get('winner_id')