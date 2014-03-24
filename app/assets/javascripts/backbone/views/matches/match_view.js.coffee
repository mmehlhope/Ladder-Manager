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
      'click .list-item-content'             : 'toggleGamesView'

    initialize: () ->
      @gameCollection     = @model.games
      @gameCollectionView = new GameCollectionView(
        collection: @gameCollection
        comp_1_name : @model.getCompetitorName(1)
        comp_2_name : @model.getCompetitorName(2)
      )

      @listenTo(@gameCollection, 'add sync destroy', @render)
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @removeEl)

      @gamesListVisible = false
      this

    render: () ->
      node = Match_t(match: @model, _view: @)
      @$el.html(node).attr('id', 'match-' + @model.get('id'))
      @$('.games-table-wrapper').append(@gameCollectionView.render().el)
      @messageCenter = new MessagesView(el: @$('.messages'))
      this

    toggleGamesView: (e, action="toggle") ->
      if e
        tag = e.target.tagName.toLowerCase()
        if (tag is 'a' || tag is 'input' || tag is 'button')
          return
        else
          e.preventDefault()
      @gamesListVisible = !@gamesListVisible
      @$(".games-table-wrapper").collapse(action)
      this

    showGamesView: () ->
      @gamesListVisible = true
      @$(".games-table-wrapper").attr('class', 'games-table-wrapper collapse in')
      this

    hideGamesView: () ->
      @gamesListVisible = false
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
      @showGamesView()
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
        @remove()
      )
      this