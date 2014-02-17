define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Backbone   = require 'backbone'
  Game_t     = require 'templates/games/game_t'

  class GameView extends Backbone.View

    tagName: 'tr'

    events:
      'submit form'                       : 'updateGame'
      'click [data-action="delete-game"]' : 'deleteGame'


    initialize: () ->
      @listenTo(@model, 'change', @render)
      this

    render: () ->
      @$el.html(Game_t(game: @model, number: @attributes.number))
      this

    updateGame: (e) ->
      e.preventDefault()
      form = $(e.target)

      $.ajax(
        url: form.attr('action')
        type: 'PUT'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          # Update the model, which triggers the row to re-render
          @model.set(jqXHR.game)
        error: (jqXHR, textStatus, errorThrown) ->
          console.log textStatus
      )
      this

    deleteGame: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete this game?")
        @model.destroy(
          success: () =>
            @destroy()
          error: () ->
            console.log 'game not deleted'
        )
      this

    destroy: () ->
      @$el.remove()
      this
