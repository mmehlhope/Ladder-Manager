define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Match_t    = require 'templates/matches/match_t'

  class MatchView extends Backbone.View
    tagName: 'tr'

    events:
      'click'                 : 'toggleGamesView'
      'click .finalize-match' : 'finalize'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      this

    render: () ->
      @$el.attr('id', 'match-' + @model.get('id'))
          .append(Match_t(match: @model))

      if @model.get('games').length
        @$el.addClass('clickable')

      this

    toggleGamesView: (e) ->
      e.preventDefault()
      $("#games-for-match-" + @model.get('id') + " .table-wrap").collapse('toggle')


    finalize: () ->
