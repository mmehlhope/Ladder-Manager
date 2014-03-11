define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Util             = require 'util'
  Backbone         = require 'backbone'
  CompetitorModel  = require 'backbone/models/competitor_model'
  NewCompetitor_t  = require 'templates/competitors/new_t'
  MessagesView     = require 'backbone/views/widgets/messages_view'

  class NewCompetitorView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'submit form'                  : 'createNewCompetitor'
      'click [data-action="cancel"]' : 'removeEl'

    initialize: () ->
      this

    render: () ->
      @$el.html(NewCompetitor_t(url: @collection.url))
      @messagesView = new MessagesView(el: @$('.messaging'))
      this

    toggleBusy: () ->
      @$('button[type="submit"]').toggleClass('busy')
      this

    createNewCompetitor: (e) ->
      e.preventDefault()
      form = $(e.target)

      @toggleBusy()

      $.ajax(
        url: form.attr('action')
        type: 'POST'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          competitor = new CompetitorModel(jqXHR.competitor)
          @removeEl(null, false)
          @collection.add(competitor)
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