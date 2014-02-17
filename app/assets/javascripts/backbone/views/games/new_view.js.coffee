define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  NewGame_t  = require 'templates/games/new_game_t'

  class NewGameView extends Backbone.View

    tagName: 'tr'

    events:
      'submit form'                  : 'createNewGame'
      'click [data-action="delete"]' : 'deleteGame'

    initialize: () ->
      @listenTo(@model, 'change', @render)
      @listenTo(@model, 'destroy', @destroy)
      this

    render: () ->
      @$el.html(NewGame_t(game: @model))
      this

    toggleBusy: () ->
      @$('button[type="submit"]').toggleClass('busy')
      this

    createNewGame: (e) ->
      e.preventDefault()
      form = $(e.target)

      @toggleBusy()

      $.ajax(
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          @trigger('newGameCreated')
        error: (jqXHR, textStatus, errorThrown) ->
          console.log textStatus
      )
      this

    deleteGame: (e) ->
      e.preventDefault()
      @model.destroy()

    destroy: () ->
      @$el.remove()
