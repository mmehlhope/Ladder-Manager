define (require, exports, module) ->

  $                = require 'jquery'
  _                = require 'underscore'
  Util             = require 'util'
  Backbone         = require 'backbone'
  CompetitorModel  = require 'backbone/models/competitor_model'
  NewCompetitor_t  = require 'templates/competitors/new_t'
  BaseNewView      = require 'backbone/views/common/base_new_view'

  class NewCompetitorView extends BaseNewView

    list_item_model: CompetitorModel
    template       : NewCompetitor_t