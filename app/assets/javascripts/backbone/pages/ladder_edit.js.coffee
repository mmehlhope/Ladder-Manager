define (require, exports, module) ->

  $                    = require 'jquery'
  Backbone             = require 'backbone'
  MatchCollection      = require 'backbone/collections/match_collection'
  MatchIndexView       = require 'backbone/views/matches/index_view'
  CompetitorCollection = require 'backbone/collections/competitor_collection'
  CompetitorIndexView  = require 'backbone/views/competitors/index_view'
  LadderModel          = require 'backbone/models/ladder_model'
  LadderDetailsView    = require 'backbone/views/ladders/details_view'

  class LadderEditPage extends Backbone.View

    el: '.management-panel'

    initialize: (options={}) ->
      {@ladder, @matches, @competitors} = options

      matchCollection           = new MatchCollection(@matches)
      matchCollection.ladder_id = @ladder.id
      matchCollection.url       = "/ladders/#{@ladder.id}/matches"
      matchIndexView            = new MatchIndexView(collection: matchCollection)
      competitorCollection      = new CompetitorCollection(@competitors)
      competitorCollection.url  = "/ladders/#{@ladder.id}/competitors"
      competitorIndexView       = new CompetitorIndexView(collection: competitorCollection)
      ladderModel               = new LadderModel(@ladder)
      LadderDetailsView         = new LadderDetailsView(model: ladderModel).render()