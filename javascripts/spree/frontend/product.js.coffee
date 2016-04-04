Spree.ready ($) ->
  Spree.addImageHandlers = ->
    thumbnails = ($ '#product-images ul.thumbnails')
    $(this).parents('[data-selected-variant]').find('#main-image img').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'
    thumbnails.find('a').on 'click', (event) ->
      $(this).parents('[data-selected-variant]').find('#main-image img').data 'selectedThumb', ($ event.currentTarget).attr('href')
      $(this).parents('[data-selected-variant]').find('#main-image img').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      thumbnails.find('li').removeClass 'selected'
      ($ event.currentTarget).parent('li').addClass 'selected'
      false

  Spree.showVariantImages = (variantId, _this) ->
    $(_this).find('li.vtmb').removeClass('show').hide()
    $(_this).find('li.tmb-' + variantId).addClass('show')
    $(_this).find('li.tmb-all').addClass('show')
    mySlider.reloadSlider()

  Spree.updateVariantPrice = (variant, _this) ->
    variantPrice = variant.data('price')
    variantCostPrice = variant.data('cost')
    variantPercentageProfit = variant.data('percentage-profit')
    $(_this).find('.price.selling').text(variantPrice) if variantPrice
    $(_this).find('.price.cost').text(variantCostPrice) if variantCostPrice
    $(_this).find('.price.percentage').text(variantPercentageProfit) if variantPercentageProfit

  mySlider = $("[data-slider='image']").bxSlider({
    mode: "horizontal",
    pager: false,
    adaptiveHeight: true,
    controls: true,
    slideSelector: '.show',
  });

  $('[data-selected-variant]').each ->
    radios = $(this).find('#product-variants input[type="radio"]')
    radios.click (event) ->
      Spree.showVariantImages(@value, $(this).parents('[data-selected-variant]'))
      Spree.updateVariantPrice($(this), $(this).parents('[data-selected-variant]'))

    if radios.length > 0
      selectedRadio = $(this).find('#product-variants input[type="radio"][checked="checked"]')
      Spree.showVariantImages(selectedRadio.attr('value'), this)
      Spree.updateVariantPrice(selectedRadio, this)

  Spree.addImageHandlers()
