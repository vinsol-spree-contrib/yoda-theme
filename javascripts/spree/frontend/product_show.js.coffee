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

  Spree.showHideVariants = (self, _this) ->
    selectedColorOption = $(_this).data('color-option-id')
    $(self).find("[data-color-option-id]").removeClass('active')
    $(_this).addClass('active')
    $(self).find("[data-select-color-option-id]").hide().removeClass("visible");
    sizeOptions = $(self).find("[data-select-color-option-id=" + selectedColorOption + "]").show().addClass("visible");
    sizeOptions.first().find('input').trigger('click')

  Spree.productQuantityField = (_this) ->
    _this.value = parseInt(_this.value) if _this.value != ''
    _this.value = 1 if _this.value == 'NaN' || _this.value < 1

  Spree.productUpdateQuantity = (_this, quantity) ->
    if _this.value == ''
      _this.value = 1
    else
      _this.value = parseInt(_this.value) + quantity
    Spree.productQuantityField(_this)

  Spree.productUpdateQuantityFieldEvent = (_this, event) ->
    if(event.keyCode == 38)
      Spree.productUpdateQuantity(_this, 1)

    if(event.keyCode == 40)
      Spree.productUpdateQuantity(_this, -1)

  quantityField = ($ "[data-hook='product-quantity']")
  quantityField.bind 'input propertychange', (event) ->
    Spree.productQuantityField(this)
  quantityField.bind 'input keyup', (event) ->
    Spree.productUpdateQuantityFieldEvent(this, event)

  incrementQuantityField = $("[data-behaviour='increment-product-quantity']")
  incrementQuantityField.bind 'click', (event) ->
    Spree.productUpdateQuantity(quantityField[0], 1)

  decrementQuantityField = $("[data-behaviour='decrement-product-quantity']")
  decrementQuantityField.bind 'click', (event) ->
    Spree.productUpdateQuantity(quantityField[0], -1)

  colorOptions = $('[data-color-option-id]')
  colorOptions.bind 'click', (event) ->
    Spree.showHideVariants($(this).parents('[data-selected-variant]'), this)
  $('[data-selected-variant]').each ->
    Spree.showHideVariants(this, colorOptions)

  mySlider = $("[data-slider='image']").first().bxSlider({
    mode: "horizontal",
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
    else
      Spree.showVariantImages('', this)

  Spree.addImageHandlers()
