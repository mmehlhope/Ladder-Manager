define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Match_t    = require 'templates/matches/match_t'

  class MatchView extends Backbone.View
    tagName: 'tr'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      this

    render: () ->
      @$el.append(Match_t(match: @model))
      this