define (require, exports, module) ->

  $                  = require 'jquery'
  _                  = require 'underscore'
  Backbone           = require 'backbone'
  Match_t            = require 'templates/matches/match_t'
  GameModel          = require 'backbone/models/game_model'
  GameCollection     = require 'backbone/collections/game_collection'
  GameCollectionView = require 'backbone/views/games/index_view'

  class MatchView extends Backbone.View

    tagName: 'tr'

    events:
      'click [data-action="add-game"]'       : 'showNewGameRow'
      'click [data-action="delete-match"]'   : 'deleteMatch'
      'click [data-action="finalize"]'       : 'finalize'
      'click .view-games'                    : 'toggleGamesView'

    initialize: () ->
      @gameCollection     = @model.get('games')
      @gameCollectionView = new GameCollectionView(collection: @gameCollection)

      @listenTo(@gameCollection, 'sync destroy', @render)
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @destroy)
      this

    render: () ->
      console.log 'rendering match'
      node = Match_t(match: @model)
      node = $(node).append(@gameCollectionView.render().el)
      @$el.html(node).attr('id', 'match-' + @model.get('id'))

      if @model.isGamesListVisible()
        @showGamesView()
      else
        @hideGamesView()
      this

    toggleGamesView: (e, action="toggle") ->
      e.preventDefault() if e
      # @model.set('visibleGamesList', bool, silent: true)
      @$(".games-table-wrapper").collapse(action)
      this

    showGamesView: () ->
      @model.set('visibleGamesList', true, silent: true)
      @toggleGamesView(null, 'show')
      this

    hideGamesView: () ->
      @model.set('visibleGamesList', false, silent: true)
      @toggleGamesView(null, 'hide')
      this

    showNewGameRow: (e) ->
      e.preventDefault()
      gameModel = new GameModel(
        match_id: @model.get('id')
      )
      @gameCollection.push(gameModel)
      @model.set('visibleGamesList', true, silent: true)
      @showGamesView()
      this

    assessGamesVisibility: () ->
      unless @gameCollection.models.length
        @model.set('visibleGamesList', false, silent: true)
        @hideGamesView()
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

    deleteMatch: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete this match?")
        @model.destroy()

    destroy: () ->
      @$el.remove()
      this