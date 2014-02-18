define (require, exports, module) ->

  Backbone = require 'backbone'

  class Message extends Backbone.Model

    defaults:
      "type": "notification"
      "removable": true
      "content" : null