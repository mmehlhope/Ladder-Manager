define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Competitor_t      = require 'templates/competitors/competitor_t'
  BaseListView      = require 'backbone/views/common/base_list_view'

  class CompetitorView extends BaseListView

    render: () ->
      @$el.html(Competitor_t(competitor: @model, _view: @))
      super
      this

    deleteItem: (e) ->
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
          alert('This competitor is in one or more unfinished matches. Please finalize these matches or delete them to allow deletion of this competitor.')

      @model.fetch(
        success: verifyDeletion
        error: (existingModel, response) ->
          @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
      )

      this