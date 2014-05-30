define (require, exports, module) ->

  $ = require 'jquery'

  Globals =

    initialize: () ->
      $(document).on('click', '.sign-out', @signOutUser)

    signOutUser: (e) ->
      e.preventDefault() if e

      request =
        $.ajax
          url: '/users/sign_out'
          method: 'delete'

      request.success () ->
        window.location = '/users/sign_in'


