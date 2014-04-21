define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Util             = require 'util'
  Backbone         = require 'backbone'
  LadderModel      = require 'backbone/models/ladder_model'
  NewLadder_t      = require 'templates/ladders/new_t'
  MessagesView     = require 'backbone/views/widgets/messages_view'

  class NewLadderView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'submit form'                  : 'createNewLadder'
      'click [data-action="cancel"]' : 'removeEl'

    initialize: () ->
      this

    render: () ->
      @$el.html(NewLadder_t(url: @collection.url))
      @messagesView = new MessagesView(el: @$('.messaging'))
      this

    toggleBusy: () ->
      @$('button[type="submit"]').toggleClass('busy')
      this

    createNewLadder: (e) ->
      e.preventDefault()
      form = $(e.target)

      @toggleBusy()

      $.ajax(
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          ladder = new LadderModel(jqXHR)
          @removeEl(null, false)
          @collection.add(ladder)
        error: (jqXHR, textStatus, errorThrown) =>
          @toggleBusy()
          @$('input').focus()
          @messagesView.post(Util.parseTransportErrors(jqXHR), 'danger', false)
          this
      )
      this

    removeEl: (e, animate=true) ->
      e.preventDefault() if e
      if animate
        @$el.slideUp(200, () =>
          @remove()
        )
      else
        @remove()