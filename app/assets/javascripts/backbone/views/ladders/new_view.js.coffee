define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Util             = require 'util'
  Backbone         = require 'backbone'
  LadderModel      = require 'backbone/models/ladder_model'
  NewLadder_t      = require 'templates/ladders/new_t'
  BaseNewView      = require 'backbone/views/common/base_new_view'

  class NewLadderView extends BaseNewView

    list_item_model: LadderModel
    template       : NewLadder_t