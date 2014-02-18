define (require, exports, module) ->

  $                    = require 'jquery'
  _                    = require 'underscore'
  Backbone             = require 'backbone'
  MatchModel           = require 'backbone/models/match_model'
  MatchCollection      = require 'backbone/collections/match_collection'
  MatchView            = require 'backbone/views/matches/match_view'
  NewMatchView         = require 'backbone/views/matches/new_view'
  Matches_t            = require 'templates/matches/index_t'

  class MatchCollectionView extends Backbone.View

    el: '#matchOpts'

    events:
      'click #record-new-match' : 'showNewMatchForm'

    initialize: () ->
      @addChildrenAndRender()
      @listenTo(@collection, 'sync', @addChildrenAndRender)
      @listenTo(@collection, 'add', @addOne)
      this

    render: () ->
      @$el.empty().html(Matches_t(matches: @collection)).find('tbody').append(@children)
      this

    addOne: (model) ->
      matchView = new MatchView(model: model)
      @$('tbody:first').prepend(matchView.render().el)
      this

    addChildrenAndRender: () ->
      @children = []

      _(@collection.models).each((model) =>
        matchView     = new MatchView(model: model)
        matchViewNode = matchView.render().el
        @children.push(matchViewNode)
      )
      @render()
      this

    toggleBusy: () ->
      @$('#record-new-match').toggleClass('busy')
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
      )
      @listenTo(newMatchView, 'fetchFinished', @toggleBusy)
      @$('table:first').prepend(newMatchView.render().el)
      this