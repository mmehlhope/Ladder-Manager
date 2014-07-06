define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  Backbone          = require 'backbone'
  Ladder_t          = require 'templates/ladders/ladder_t'
  BaseListItemView  = require 'backbone/views/common/base_list_item_view'

  class LadderView extends BaseListItemView

    render: () ->
      @$el.html(Ladder_t(ladder: @model, _view: @))
      super

    deleteItem: (e) ->
      e.preventDefault() if e

      if confirm("Are you sure you want to delete #{@model.get('name')}? This will permanently delete all matches and competitors that belong to this ladder.")
        @model.destroy(
          success: () =>
            @removeEl()
          error: (existingModel, response) =>
            @messageCenter.post(Util.parseTransportErrors(response), 'danger', false)
        )
      else
        false
