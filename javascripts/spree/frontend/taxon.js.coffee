Spree.ready ($) ->

  $("[data-show-taxon]").hover ( ->
    $(this).dropdown('toggle')
  ), ->
    $(this).dropdown('toggle')
