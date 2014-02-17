define (require, exports, module) ->

  Backbone       = require 'backbone'
  GameCollection = require 'backbone/collections/game_collection'

  class MatchModel extends Backbone.Model

    initialize: () ->
      @set('games', new GameCollection(@get('games')))
      @get('games').url      = @urlRoot + '/' + @get('id') + '/games'
      @get('games').match_id = @get('id')
      @set('visibleGamesList', false)

    urlRoot: '/matches'

    isGamesListVisible: () ->
      @get('visibleGamesList')

    isFinalized: () ->
      @get('finalized')

    has_games: () ->
      @get('games').length > 0

    competitor_1_is_winner: () ->
      @get('competitor_1').id == @get('winner_id')

    competitor_2_is_winner: () ->
      @get('competitor_2').id == @get('winner_id')