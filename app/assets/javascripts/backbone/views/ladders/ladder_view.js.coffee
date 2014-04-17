define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Ladder_t          = require 'templates/competitors/competitor_t'
  MessageModel      = require 'backbone/models/message_model'
  MessagesView      = require 'backbone/views/widgets/messages_view'

  class LadderView extends Backbone.View

    tagName: 'li'
    className: 'list-item'

    events:
      'submit form'                             : 'updateLadder'
      'click [data-action="delete-ladder"]'     : 'deleteLadder'
      'click [data-action="edit"]'              : 'toggleEditMode'
      'click [data-action="cancel"]'            : 'toggleEditMode'


    initialize: () ->
      @listenTo(@model, 'change', @render)
      @editMode = false
      this

    render: () ->
      @$el.html(Ladder_t(ladder: @model, _view: @))
      @messageCenter = new MessagesView(el: @$('.messaging'))
      if @inEditMode
        @$('input').focus()

      this

    updateLadder: (e) ->
      e.preventDefault()
      form = $(e.target)

      $.ajax(
        url: form.attr('action')
        type: 'PUT'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          # Update the model and trigger the change event whether or not it actually happens.
          # User may submit non-changing value, but view should still re-render
          @editMode = false
          @model.set(jqXHR.ladder, {silent: true})
          @model.trigger('change')
        error: (jqXHR, textStatus, errorThrown) =>
          @render()
          @$('input').focus()
          @messageCenter.clear()
          @messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger', false)
      )
      this

    deleteLadder: (e) ->
      e.preventDefault() if e

      verifyDeletion = () =>
        if @model.can_be_deleted()
          if confirm("Are you sure you want to delete #{@model.get('name')}? You cannot undo this action.")
            @model.destroy(
              success: () =>
                @removeEl()
              error: (existingModel, response) =>
                @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
            )
        else
          alert('This ladder is in one or more unfinished matches. Please finalize these matches or delete them to allow deletion of this ladder.')

      @model.fetch(
        success: verifyDeletion
        error: (existingModel, response) ->
          @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
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
      @$el.slideUp(() =>
        @remove()
      )
      this
