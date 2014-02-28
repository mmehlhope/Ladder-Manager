define (require, exports, module) ->

  $                  = require 'jquery'
  _                  = require 'underscore'
  Backbone           = require 'backbone'
  Match_t            = require 'templates/matches/match_t'
  GameModel          = require 'backbone/models/game_model'
  GameCollectionView = require 'backbone/views/games/index_view'

  class MatchView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'click [data-action="add-game"]'       : 'showNewGameRow'
      'click [data-action="delete-match"]'   : 'deleteMatch'
      'click [data-action="finalize"]'       : 'finalize'
      'click .view-games'                    : 'toggleGamesView'

    initialize: () ->
      @gameCollection     = @model.games
      @gameCollectionView = new GameCollectionView(collection: @gameCollection)

      @listenTo(@gameCollection, 'sync destroy', @render)
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @destroy)
      this

    render: () ->
      node = Match_t(match: @model)
      @$el.html(node).attr('id', 'match-' + @model.get('id'))
      @$el.append(@gameCollectionView.render().el)
      @newGameInProgress = false
      @assessGamesVisibility()
      this

    toggleGamesView: (e, action="toggle") ->
      e.preventDefault() if e
      @$(".games-table-wrapper").collapse(action)
      this

    showGamesView: (now) ->
      @model.set('visibleGamesList', true, silent: true)
      unless now
        @toggleGamesView(null, 'show')
      else
        @$(".games-table-wrapper").attr('class', 'games-table-wrapper collapse in')
      this

    hideGamesView: (now) ->
      @model.set('visibleGamesList', false, silent: true)
      unless now
        @toggleGamesView(null, 'hide')
      else
        @$(".games-table-wrapper").attr('class', 'games-table-wrapper collapse')
      this

    showNewGameRow: (e) ->
      unless @newGameInProgress
        e.preventDefault()
        @newGameInProgress = true
        gameModel = new GameModel(
          match_id: @model.get('id')
        )
        @gameCollection.push(gameModel)
        @model.set('visibleGamesList', true, silent: true)
        @showGamesView()
      else
        alert('A new game is already in progress of being added')
      this

    assessGamesVisibility: () ->
      if @model.has_games() && @model.isGamesListVisible()
        @showGamesView(true)
      else
        @hideGamesView(true)
      this

    finalize: (e) ->
      e.preventDefault()
      if confirm('If you finalize the match, it can no longer be edited.\n\nAdditionally, competitor records and ratings will be permanently adjusted. Are you sure you wish to finalize this match?')
        $.ajax(
          url: '/matches/' + @model.get('id') + '/finalize'
          type: 'POST'
          dataType: 'json'
          success: (jqXHR, textStatus) =>
            @model.trigger('finalize')
            @destroy()
          error: (jqXHR, textStatus, errorThrown) ->
            console.log textStatus
        )
      this

    deleteMatch: (e) ->
      e.preventDefault()
      if confirm('Are you sure you want to delete this match?')
        @model.destroy()

    destroy: () ->
      @$el.remove()
      this