define (require, exports, module) ->

  $              = require 'jquery'
  _              = require 'underscore'
  Util           = require 'util'
  Backbone       = require 'backbone'
  UserModel      = require 'backbone/models/user_model'
  NewUser_t      = require 'templates/users/new_t'
  BaseNewView    = require 'backbone/views/common/base_new_view'

  class NewUserView extends BaseNewView

    list_item_model: UserModel

    render: () ->
      @$el.html(NewUser_t(url: @collection.url))
      super
      this