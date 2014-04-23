define (require, exports, module) ->

  $              = require 'jquery'
  _              = require 'underscore'
  Util           = require 'util'
  Backbone       = require 'backbone'
  MessagesView   = require 'backbone/views/widgets/messages_view'

  class BaseNewView extends Backbone.View

    list_item_model: () ->
      # populate in extended view

    tagName: 'li'
    className: 'list-item'

    events:
      'submit form'                  : 'createNewUser'
      'click [data-action="cancel"]' : 'removeEl'

    initialize: () ->
      this

    render: () ->
      @messagesView = new MessagesView(el: @$('.messaging'))
      this

    toggleBusy: () ->
      @$('button[type="submit"]').toggleClass('busy')
      this

    createNewItem: (e) ->
      e.preventDefault()
      form = $(e.target)

      @toggleBusy()

      $.ajax(
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          item = new @list_item_model(jqXHR)
          @removeEl(null, false)
          @collection.add(user)
        error: (jqXHR, textStatus, errorThrown) =>
          @toggleBusy()
          @$('input:first').focus()
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