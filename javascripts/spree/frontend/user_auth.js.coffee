Spree.ready ($) ->

  Spree.handleAuthContainers = (action_url) ->
    $("[data-display-url]").parents("[data-display-section]").addClass('hidden')
    $("[data-display-url='" + action_url + "']").parents("[data-display-section]").removeClass('hidden')

  Spree.handleAuthContainers(window.location.pathname)
  $("[data-auth-action]").on 'click', (event) ->
    Spree.handleAuthContainers($(this).data('auth-action'))
