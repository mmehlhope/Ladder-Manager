define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Match_t    = require 'templates/matches/match_t'

  class MatchView extends Backbone.View
    tagName: 'tr'

    events:
      'click [data-action="delete"]'   : 'deleteMatch'
      'click [data-action="finalize"]' : 'finalize'
      'click .view-games'              : 'toggleGamesView'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @destroy)
      this

    render: () ->
      @$el.attr('id', 'match-' + @model.get('id')).append(Match_t(match: @model))
      this

    toggleGamesView: (e) ->
      e.preventDefault()
      $("#games-for-match-" + @model.get('id') + " .table-wrap").collapse('toggle')


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

    deleteMatch: () ->
      @model.destroy()

    destroy: () ->
      @$el.fadeOut()
      this