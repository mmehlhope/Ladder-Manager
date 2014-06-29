define (require, exports, module) ->

  Backbone = require 'backbone'

  class CompetitorModel extends Backbone.Model
    urlRoot: '/competitors'

    has_unfinished_matches: () ->
      @get('has_unfinished_matches')

    can_be_deleted: () ->
      !@has_unfinished_matches()

    can_edit: () ->
      @get('can_edit')
