define (require, exports, module) ->

  Backbone = require 'backbone'

  class Message extends Backbone.Model

    defaults:
      "type": "info"
      "removable": true
      "content" : null