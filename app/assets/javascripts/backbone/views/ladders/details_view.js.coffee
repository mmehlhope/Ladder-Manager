define (require, exports, module) ->

  $            = require 'jquery'
  _            = require 'underscore'
  Util         = require 'util'
  Backbone     = require 'backbone'
  Details_t    = require 'templates/ladders/details_t'
  MessagesView = require 'backbone/views/widgets/messages_view'

  class DetailsView extends Backbone.View

    el: '#ladders'

    events:
      'submit form'                         : 'updateDetails'
      'click [data-action="delete-ladder"]' : 'deleteDetails'
      'click [data-action="edit"]'          : 'toggleEditMode'
      'click [data-action="cancel"]'        : 'toggleEditMode'


    initialize: () ->
      @listenTo(@model, 'change', @render)
      @editMode = false
      this

    render: () ->
      @$el.html(Details_t(ladder: @model, _view: @))
      @messageCenter = new MessagesView(el: @$('.messaging'))
      if @inEditMode()
        @$('input:first').focus()
      this

    updateDetails: (e) ->
      e.preventDefault()
      form = $(e.target)

      $.ajax(
        url: form.attr('action')
        type: 'PUT'
        dataType: 'json'
        data: form.serialize()
        success: (jqXHR, textStatus) =>
          console.log jqXHR
          # Update the model, which triggers the row to re-render
          @editMode = false
          # force update
          @model.set(jqXHR.ladder, {silent: true})
          @model.trigger('change')
          @messageCenter.clear().post('Ladder was successfully updated!', 'success')
        error: (jqXHR, textStatus, errorThrown) =>
          @render()
          @$('input:first').focus()
          @messageCenter.post(Util.parseTransportErrors(jqXHR), 'danger', false)
          this

      )
      this

    deleteDetails: (e) ->
      e.preventDefault()
      if confirm("Are you sure you want to delete this ladder?")
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
