define (require, exports, module) ->

  $                  = require 'jquery'
  _                  = require 'underscore'
  Backbone           = require 'backbone'
  Util               = require 'util'
  Match_t            = require 'templates/matches/match_t'
  NewGameView        = require 'backbone/views/games/new_view'
  GameModel          = require 'backbone/models/game_model'
  GameCollectionView = require 'backbone/views/games/index_view'
  MessagesView       = require 'backbone/views/widgets/messages_view'


  class MatchView extends Backbone.View

    tagName: 'li'
    className: 'list-item bordered'

    events:
      'click [data-action="deleteMatch"]'   : 'deleteItem'
      'click [data-action="add-game"]' : 'showNewGameRow'
      'click [data-action="finalize"]' : 'finalize'

    initialize: (options={}) ->
      @gameCollection     = @model.games
      @gameCollectionView = new GameCollectionView(
        collection: @gameCollection
        comp_1_name : @model.getCompetitorName(1)
        comp_2_name : @model.getCompetitorName(2)
      )
      @contextView = options.contextView

      @listenTo(@gameCollection, 'add sync destroy', @render)
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @removeEl)
      @gamesListVisible = true
      this

    render: () ->
      node = Match_t(match: @model, _view: @)
      @$el.html(node).attr('id', 'match-' + @model.get('id'))
      @$('.games-table-wrapper').append(@gameCollectionView.render().el)
      @determineIfSampleGameIsNeeded()
      @messageCenter = new MessagesView(el: @$('.messages'))
      this

    determineIfSampleGameIsNeeded: () ->
      @showNewGameRow() if @gameCollection.length is 0
    
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
      @focusGameInput()
      this

    focusGameInput: () ->
      @$('.games-table-wrapper:first input:first').focus()

    finalize: (e) ->
      e.preventDefault() if e

      if confirm("Locking-in the results of this match will permanently update these competitors' ratings.\n\nThis match will no longer be editable after it has been locked. Do you want to lock this match?")
        $.ajax(
          url: '/matches/' + @model.get('id') + '/finalize'
          type: 'POST'
          dataType: 'json'
          success: (jqXHR, textStatus) =>
            @model.trigger('finalize')
            @removeEl()
          error: (jqXHR, textStatus, errorThrown) =>
            @contextView.messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger')
        )
      this

    deleteItem: (e) ->
      e.preventDefault() if e

      if confirm('Are you sure you want to delete this match?')
        @model.destroy()

    removeEl: () ->
      @$el.slideUp(() =>
        @remove()
      )
      this
