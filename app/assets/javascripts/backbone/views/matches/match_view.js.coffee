define (require, exports, module) ->

  $                  = require 'jquery'
  _                  = require 'underscore'
  Backbone           = require 'backbone'
  Match_t            = require 'templates/matches/match_t'
  NewGameView        = require 'backbone/views/games/new_view'
  GameModel          = require 'backbone/models/game_model'
  GameCollectionView = require 'backbone/views/games/index_view'
  MessagesView       = require 'backbone/views/widgets/messages_view'

  class MatchView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'click [data-action="add-game"]'       : 'showNewGameRow'
      'click [data-action="delete-match"]'   : 'deleteMatch'
      'click [data-action="finalize"]'       : 'finalize'
      'click .view-games'                    : 'toggleGamesView'
      'click'                                : 'toggleGamesView'

    initialize: () ->
      @gameCollection     = @model.games
      @gameCollectionView = new GameCollectionView(
        collection: @gameCollection
        comp_1_name : @model.getCompetitorName(1)
        comp_2_name : @model.getCompetitorName(2)
      )

      @listenTo(@gameCollection, 'sync destroy', @render)
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @removeEl)
      this

    render: () ->
      node = Match_t(match: @model)
      @$el.html(node).attr('id', 'match-' + @model.get('id'))
      @$el.append(@gameCollectionView.render().el)
      @newGameInProgress = false
      @messageCenter = new MessagesView(el: @$('.messages'))
      @assessGamesVisibility()
      this

    toggleGamesView: (e, action="toggle") ->
      if e
        tag = e.target.tagName.toLowerCase()
        if (tag is 'a' || tag is 'input' || tag is 'button')
          return
        else
          e.preventDefault()

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
      if e
        e.preventDefault()
        e.stopPropagation()

      newGameView = new NewGameView(
        collection  : @gameCollection
        comp_1_name : @model.getCompetitorName(1)
        comp_2_name : @model.getCompetitorName(2)
      )
      @$('tbody').append(newGameView.render().el)
      @model.set('visibleGamesList', true, silent: true)
      @showGamesView()
      this

    assessGamesVisibility: () ->
      if @model.has_games() && @model.isGamesListVisible()
        @showGamesView(true)
      else
        @hideGamesView(true)
      this

    finalize: (e) ->
      if e
        e.preventDefault()

      if confirm("Locking-in the results of this match will permanently update these competitors' ratings.\n\nThis match will no longer be editable after it has been locked. Do you want to lock this match?")
        $.ajax(
          url: '/matches/' + @model.get('id') + '/finalize'
          type: 'POST'
          dataType: 'json'
          success: (jqXHR, textStatus) =>
            @model.trigger('finalize')
            @removeEl()
          error: (jqXHR, textStatus, errorThrown) ->
            console.log textStatus
        )
      this

    deleteMatch: (e) ->
      if e
        e.preventDefault()

      if confirm('Are you sure you want to delete this match?')
        @model.destroy()

    removeEl: () ->
      @$el.slideUp(() =>
        @$el.remove()
      )
      this