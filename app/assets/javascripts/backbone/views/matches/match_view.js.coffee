define (require, exports, module) ->

  $                  = require 'jquery'
  _                  = require 'underscore'
  Backbone           = require 'backbone'
  Match_t            = require 'templates/matches/match_t'
  GameModel          = require 'backbone/models/game_model'
  GameCollection     = require 'backbone/collections/game_collection'
  GameCollectionView = require 'backbone/views/games/index_view'
  # NewGameView = require 'backbone/views/games/new_view'

  class MatchView extends Backbone.View

    tagName: 'tr'

    events:
      'click [data-action="add-game"]' : 'showNewGameRow'
      'click [data-action="delete"]'   : 'deleteMatch'
      'click [data-action="finalize"]' : 'finalize'
      'click .view-games'              : 'toggleGamesView'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @destroy)
      this

    render: () ->
      @$el.attr('id', 'match-' + @model.get('id')).append(Match_t(match: @model))
      this

    toggleGamesView: (e) ->
      e.preventDefault() if e
      $("#games-for-match-" + @model.get('id') + " .table-wrap").collapse('toggle')
      this

    showNewGameRow: (e) ->
      e.preventDefault()

      gameModel = new GameModel(
        match_id: @model.get('id')
        competitor_1_score: 0
        competitor_2_score: 0
      )

      unless @gameCollection
        @gameCollection     = new GameCollection(gameModel, silent: true)
        @gameCollectionView = new GameCollectionView(collection: @gameCollection)
        $(@gameCollectionView.render().el).insertAfter(@$el)

        gamesTable = $("#games-for-match-" + @model.get('id') + " .table-wrap")
        if !gamesTable.hasClass('in')
          console.log 'toggling view'
          @toggleGamesView()

      else
        @gameCollection.push(gameModel)
      this

    finalize: (e) ->
      e.preventDefault()

      $.ajax(
        url: '/matches/' + @model.get('id') + '/finalize'
        type: 'POST'
        dataType: 'json'
        success: (jqXHR, textStatus) =>
          @destroy()
        error: (jqXHR, textStatus, errorThrown) ->
          console.log textStatus
      )
      this

    deleteMatch: () ->
      if confirm("Are you sure you want to delete this match?")
        @model.destroy()

    destroy: () ->
      @$el.fadeOut()
      this