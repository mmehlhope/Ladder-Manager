define (require, exports, module) ->

  $ = require 'jquery'

  Globals =

    initialize: () ->
      $(document).on('click', '.sign-out', @signOutUser)

      # Add security tokens to all AJAX requests on site
      $.ajaxSetup
        beforeSend: (xhr, settings) ->
          return if settings.crossDomain
          return if settings.type is "GET"

          token = $('meta[name="csrf-token"]').attr('content')
          xhr.setRequestHeader('X-CSRF-Token', token) if token

    signOutUser: (e) ->
      e.preventDefault() if e

      request =
        $.ajax
          url: '/users/sign_out'
          method: 'delete'

      request.success () ->
        window.location = '/users/sign_in'


