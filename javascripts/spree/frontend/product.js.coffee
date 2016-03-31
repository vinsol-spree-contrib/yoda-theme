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

    thumbnails.find('li').on 'mouseenter', (event) ->
      $(this).parents('[data-selected-variant]').find('#main-image img').attr 'src', ($ event.currentTarget).find('a').attr('href')

    thumbnails.find('li').on 'mouseleave', (event) ->
      $(this).parents('[data-selected-variant]').find('#main-image img').attr 'src', $(this).parents('[data-selected-variant]').find('#main-image').data('selectedThumb')

  Spree.showVariantImages = (variantId, _this) ->
    $(_this).find('li.vtmb').hide()
    $(_this).find('li.tmb-' + variantId).show()
    currentThumb = ($ '#' + $(this).parents('[data-selected-variant]').find('#main-image').data('selectedThumbId'))
    if not currentThumb.hasClass('vtmb-' + variantId)
      thumb = $(_this).find('#product-images ul.thumbnails li:visible.vtmb').eq(0)
      thumb = $(_this).find('#product-images ul.thumbnails li:visible').eq(0) unless thumb.length > 0
      newImg = thumb.find('a').attr('href')
      $(_this).find('#product-images ul.thumbnails li').removeClass 'selected'
      thumb.addClass 'selected'
      $(_this).find('#main-image img').attr 'src', newImg
      $(_this).find('#main-image').data 'selectedThumb', newImg
      $(_this).find('#main-image').data 'selectedThumbId', thumb.attr('id')

  Spree.updateVariantPrice = (variant, _this) ->
    variantPrice = variant.data('price')
    variantCostPrice = variant.data('cost')
    variantPercentageProfit = variant.data('percentage-profit')
    $(_this).find('.price.selling').text(variantPrice) if variantPrice
    $(_this).find('.price.cost').text(variantCostPrice) if variantCostPrice
    $(_this).find('.price.percentage').text(variantPercentageProfit) if variantPercentageProfit

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
