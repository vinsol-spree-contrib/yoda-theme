Spree.ready ($) ->
  $("[data-flash-message]").on 'click', () ->
    $('[data-flash-container]').slideUp()

  setTimeout (->
    $('[data-flash-container]').slideUp()
  ), 5000
