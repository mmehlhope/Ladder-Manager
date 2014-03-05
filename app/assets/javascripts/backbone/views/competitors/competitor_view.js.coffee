define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Competitor_t      = require 'templates/competitors/competitor_t'
  MessageModel      = require 'backbone/models/message_model'
  MessagesView      = require 'backbone/views/widgets/messages_view'

  class CompetitorView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'submit form'                             : 'updateCompetitor'
      'click [data-action="delete-competitor"]' : 'deleteCompetitor'
      'click [data-action="edit"]'              : 'toggleEditMode'
      'click [data-action="cancel"]'            : 'toggleEditMode'


    initialize: () ->
      @listenTo(@model, 'change', @render)
      @editMode = false
      this

    render: () ->
      @$el.html(Competitor_t(competitor: @model, _view: @))
      @messagesView = new MessagesView(el: @$('.messaging'))
      this

    updateCompetitor: (e) ->
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
          @model.set(jqXHR.competitor)
        error: (jqXHR, textStatus, errorThrown) =>
          @messagesView.post(Util.parseTransportErrors(jqXHR), 'danger')
      )
      this

    deleteCompetitor: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete #{@model.get('name')}? You cannot undo this action.")
        @model.destroy(
          success: () =>
            @destroy()
          error: (existingModel, response) =>
            @messagesView.post(Util.parseTransportErrors(response), 'danger')
        )
      this

    toggleEditMode: (e) ->
      e.preventDefault() if e
      @editMode = !@editMode
      @render()
      this

    inEditMode: () ->
      @editMode

    destroy: () ->
      @$el.remove()
      this
