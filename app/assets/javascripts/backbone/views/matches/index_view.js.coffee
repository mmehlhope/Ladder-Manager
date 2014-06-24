define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Backbone             = require 'backbone'
  Globals              = require 'globals'
  MatchModel           = require 'backbone/models/match_model'
  MatchCollection      = require 'backbone/collections/match_collection'
  MatchView            = require 'backbone/views/matches/match_view'
  NewMatchView         = require 'backbone/views/matches/new_view'
  MessagesView         = require 'backbone/views/widgets/messages_view'
  Matches_t            = require 'templates/matches/index_t'

  class MatchCollectionView extends Backbone.View

    el: '#matches'

    events:
      'click #record-new-match' : 'showNewMatchForm'

    initialize: () ->
      @addChildrenAndRender()
      @messageCenter = new MessagesView(el: @$('.messaging:first'))

      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      @listenTo(@collection, 'finalize', @showFinalizeSuccess)
      this

    render: () ->
      @$el.empty().html(Matches_t(matches: @collection)).find('.list-view').append(@children)
      this

    addOne: (model) ->
      matchView     = new MatchView
        model       : model
        contextView : @

      matchViewNode = matchView.render().el
      @$('.list-view').prepend(matchViewNode)
      this

    addChildrenAndRender: () ->
      @children = []

      _(@collection.models).each((model) =>
        matchView     = new MatchView
          model       : model
          contextView : @

        matchViewNode = matchView.render().el
        @children.push(matchViewNode)
      )
      @render()
      this

    toggleBusy: () ->
      @$('#record-new-match').toggleClass('busy')
      this

    showFinalizeSuccess: () ->
      Globals.postGlobalSuccess("The match was successfully finalized! Competitor rankings and ratings have been updated.")
      this

    updateCollection: () ->
      @collection.fetch()
      this

    showNewMatchForm: (e) ->
      e.preventDefault()
      @toggleBusy()

      newMatchView = new NewMatchView(
        collection  : @collection
        ladder_id   : @collection.ladder_id
        contextView : @
      )
      @listenTo(newMatchView, 'fetchFinished', @toggleBusy)
      @$('.list-view').prepend(newMatchView.render().el)
      this
