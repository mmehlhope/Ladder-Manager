define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Backbone         = require 'backbone'
  MatchView        = require 'backbone/views/matches/match_view'

  class MatchCollectionView extends Backbone.View

    el: '#edit-matches table tbody'

    tagName: 'table'

    initialize: () ->
      @children = []
      _(@collection.models).each((model) =>
        console.log model
        matchView = new MatchView(model: model)
        @children.push(matchView.render().el)
      )
      @render()
      this

    render: () ->
      console.log 'rendering collection view'
      @$el.empty().html(@children)
      this

    addOne: () ->
      _(@collection).each((model) =>
        matchView = new MatchView(model: model)
        @nodes.push(matchView.render.el())
      )
      @render()