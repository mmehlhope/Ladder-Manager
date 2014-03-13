define (require, exports, module) ->

  Backbone       = require 'backbone'
  GameCollection = require 'backbone/collections/game_collection'

  class MatchModel extends Backbone.Model

    initialize: () ->
      @games          = new GameCollection(@get('games'))
      @games.url      = @urlRoot + '/' + @get('id') + '/games'
      @games.match_id = @get('id')
      @set('visibleGamesList', false)

    urlRoot: '/matches'

    isGamesListVisible: () ->
      @get('visibleGamesList')

    isFinalized: () ->
      @get('finalized')

    has_games: () ->
      @games.length > 0

    competitor_1_is_winner: () ->
      @get('competitor_1').id == @get('winner_id')

    competitor_2_is_winner: () ->
      @get('competitor_2').id == @get('winner_id')

    getCompetitorName: (competitor_number=1) ->
      if @get('competitor_' + competitor_number)
        @get('competitor_' + competitor_number).name
      else
        "(N/A)"