define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Backbone             = require 'backbone'
  MatchView            = require 'backbone/views/matches/match_view'
  GameCollection       = require 'backbone/collections/game_collection'
  GameCollectionView   = require 'backbone/views/games/index_view'

  class MatchCollectionView extends Backbone.View

    el: '#edit-matches table > tbody'

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
      @$el.empty().html(@children)
      this