define (require, exports, module) ->

  $                 = require 'jquery'
  _                 = require 'underscore'
  Util              = require 'util'
  DetailsRename_t   = require 'templates/ladders/details_rename_t'
  BaseListItemView  = require 'backbone/views/common/base_list_item_view'

  class LadderDetailsRenameView extends BaseListItemView

    render: () ->
      @$el.html(DetailsRename_t(ladder: @model, _view: @))
      super
      this