define (require, exports, module) ->

  $          = require 'jquery'
  _          = require 'underscore'
  Util       = require 'util'
  Backbone   = require 'backbone'
  NewGame_t  = require 'templates/games/new_game_t'
  GameModel  = require 'backbone/models/game_model'
  MessagesView = require 'backbone/views/widgets/messages_view'

  class NewGameView extends Backbone.View

    tagName: 'tr'

    events:
      'submit form'                  : 'createNewGame'
      'click [data-action="cancel"]' : 'removeEl'

    initialize: (options) ->
      @options = options
      this

    render: () ->
      @$el.html(NewGame_t(collection: @collection, comp_1_name: @options.comp_1_name, comp_2_name: @options.comp_2_name))
      @messagesView = new MessagesView(el: @$('.messaging'))
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
          game = new GameModel(jqXHR.game)
          game.set('number', @collection.length+1)
          @removeEl(null, false)
          @collection.add(game)
        error: (jqXHR, textStatus, errorThrown) =>
          @render()
          @messagesView.clear()
          @messagesView.post(Util.parseTransportErrors(jqXHR), 'danger', false)
          @$('input:first').focus()
          this
      )
      this

    removeEl: (e) ->
      e.preventDefault() if e
      @$el.remove()
      this
