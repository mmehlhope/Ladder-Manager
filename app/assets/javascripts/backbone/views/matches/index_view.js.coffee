define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Backbone             = require 'backbone'
  MatchModel           = require 'backbone/models/match_model'
  MatchView            = require 'backbone/views/matches/match_view'
  NewMatchView         = require 'backbone/views/matches/new_view'
  Matches_t            = require 'templates/matches/index_t'
  GameCollection       = require 'backbone/collections/game_collection'
  GameCollectionView   = require 'backbone/views/games/index_view'

  class MatchCollectionView extends Backbone.View

    el: '#matchOpts'

    events:
      'click #record-new-match' : 'showNewMatchForm'

    initialize: () ->
      @children = []

      _(@collection.models).each((model) =>
        matchView = new MatchView(model: model)
        matchView = matchView.render().el

        if model.get('games').length
          gameCollection = new GameCollection(model.get('games'))
          gameCollectionView = new GameCollectionView(collection: gameCollection)
          gamesView = gameCollectionView.render().el
          @children.push(matchView, gamesView)
        else
          @children.push(matchView)
      )
      @render()
      this

    render: () ->
      @$el.empty().html(Matches_t(matches: @collection)).find('tbody').append(@children)
      this

    showNewMatchForm: (e) ->
      e.preventDefault()
      model = new MatchModel
      newMatchView = new NewMatchView(model: model)
      @$el.find('table:first').prepend(newMatchView.render().el)