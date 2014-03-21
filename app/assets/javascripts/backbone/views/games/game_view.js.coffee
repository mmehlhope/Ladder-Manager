define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Util       = require 'util'
  Backbone   = require 'backbone'
  Game_t     = require 'templates/games/game_t'
  MessagesView = require 'backbone/views/widgets/messages_view'

  class GameView extends Backbone.View

    tagName: 'tr'

    events:
      'submit form'                       : 'updateGame'
      'click [data-action="delete-game"]' : 'deleteGame'
      'click [data-action="edit"]'        : 'toggleEditMode'
      'click [data-action="cancel"]'      : 'toggleEditMode'


    initialize: () ->
      @listenTo(@model, 'change', @render)
      @editMode = false
      this

    render: () ->
      @$el.html(Game_t(game: @model, _view: @))
      @messageCenter = new MessagesView(el: @$('.messaging'))
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
          @editMode = false
          @model.set(jqXHR.game)
        error: (jqXHR, textStatus, errorThrown) =>
          @render()
          @$('input:first').focus()
          @messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger', false)
          this

      )
      this

    deleteGame: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete this game?")
        @model.destroy(
          success: () =>
            @removeEl()
          error: () =>
            @messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger', false)
            this
        )
      this

    toggleEditMode: (e) ->
      e.preventDefault() if e
      @editMode = !@editMode
      @render()
      this

    inEditMode: () ->
      @editMode

    removeEl: () ->
      @remove()
      this
