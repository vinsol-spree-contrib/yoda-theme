Spree.ready ($) ->

  $("[data-show-taxon]").hover ( ->
    $($(this).find('a')[0]).dropdown('toggle')
  ), ->
    $($(this).find('a')[0]).dropdown('toggle')
