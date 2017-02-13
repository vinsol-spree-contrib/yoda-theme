Spree.ready ($) ->
  Spree.addImageHandlers = (productParent) ->
    thumbnails = ($ '#product-images ul.thumbnails')
    $(this).parents(productParent).find('#main-image img').data 'selectedThumb', ($ '#main-image img').attr('src')
    thumbnails.find('li').eq(0).addClass 'selected'
    thumbnails.find('a').on 'click', (event) ->
      $(this).parents(productParent).find('#main-image img').data 'selectedThumb', ($ event.currentTarget).attr('href')
      $(this).parents(productParent).find('#main-image img').data 'selectedThumbId', ($ event.currentTarget).parent().attr('id')
      thumbnails.find('li').removeClass 'selected'
      ($ event.currentTarget).parent('li').addClass 'selected'

  Spree.showVariantImages = (variantId, _this) ->
    mainProduct = $(_this).find("[data-slider='image']")
    if(mainProduct.size() == 1)
      $(_this).find('li.vtmb').removeClass('show').hide()
      $(_this).find('li.tmb-' + variantId).addClass('show')
      $(_this).find('li.tmb-all').addClass('show')
      Spree.productImageSlider.reloadSlider() if Spree.productImageSlider
    else
      $(_this).find('li.vtmb').hide()
      if $(_this).find('li.tmb-' + variantId).size() > 0
        $(_this).find('li.tmb-all').hide()
        $(_this).find('li.tmb-' + variantId).first().show()
      else
        $(_this).find('li.tmb-all').hide()
        $(_this).find('li.tmb-all').first().show()

  Spree.updateVariantPrice = (variant, _this) ->
    variantPrice = variant.data('price')
    variantCostPrice = variant.data('cost')
    variantPercentageProfit = variant.data('percentage-profit')
    $(_this).find('.price.selling').text(variantPrice) if variantPrice
    $(_this).find('.price.cost').text(variantCostPrice) if variantCostPrice
    $(_this).find('.price.percentage').text(variantPercentageProfit) if variantPercentageProfit

  Spree.showHideVariants = (self, _this) ->
    selectedColorOption = $(self).find(_this).data('color-option-id')
    $(self).find("[data-color-option-id]").removeClass('active')
    $(self).find(_this).first().addClass('active')
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

  Spree.initializeSlider = (productParent) ->
    if $(".apr-slide").size() > 1
      $(".apr-slider").bxSlider({
        mode: "fade",
        auto: true,
        pager: false,
        adaptiveHeight: true,
        controls: false,

      });

    if $(productParent).find("[data-slider='image']").find('img').size() > 1
      Spree.productImageSlider = $(productParent).find("[data-slider='image']").find('ul').bxSlider({
        mode: "horizontal",
        adaptiveHeight: true,
        controls: true,
        slideSelector: '.show',
      });

  Spree.handleQuantityField = () ->
    quantityField = ($ "[data-hook='product-quantity']")
    quantityField.on 'input propertychange', (event) ->
      Spree.productQuantityField(this)
    quantityField.on 'input keyup', (event) ->
      Spree.productUpdateQuantityFieldEvent(this, event)

    incrementQuantityField = $("[data-behaviour='increment-product-quantity']")
    incrementQuantityField.on 'click', (event) ->
      Spree.productUpdateQuantity(quantityField[0], 1)

    decrementQuantityField = $("[data-behaviour='decrement-product-quantity']")
    decrementQuantityField.on 'click', (event) ->
      Spree.productUpdateQuantity(quantityField[0], -1)

  Spree.showContent = (_event, self) ->
    selectedModal = $($(self).data('target'))
    selectedModalId = selectedModal.attr('id')
    selectedModal.modal('show')
    $($($(self).data('target'))).on 'shown.bs.modal', ->
      selectedModal.find('.details').html($("[data-product-details='" + selectedModalId + "']").html())
      selectedModal.find('.images').html($("[data-product-images='" + selectedModalId + "']").html())
      Spree.initializeSlider("[data-selected-variant-modal='" + selectedModalId + "']")
      Spree.initializeProductShow("[data-selected-variant-modal='" + selectedModalId + "']")

  Spree.initializeProductShow = (productParent) ->

    Spree.handleQuantityField()

    $('.variant-description').click ->
      $(this).prev().click()

    colorOptions = $('[data-color-option-id]')
    colorOptions.on 'click', (event) ->
      Spree.showHideVariants($(this).parents(productParent), this)
    $(productParent).each ->
      Spree.showHideVariants(this, colorOptions)

    $(productParent).each ->
      radios = $(this).find('input[type="radio"]')
      radios.click (event) ->
        Spree.showVariantImages(this.value, $(this).parents(productParent))
        Spree.updateVariantPrice($(this), $(this).parents(productParent))

      if radios.length > 0
        selectedRadio = $(this).find('#product-variants input[type="radio"][checked="checked"]')
        Spree.showVariantImages(selectedRadio.attr('value'), this)
        Spree.updateVariantPrice(selectedRadio, this)
      else
        Spree.showVariantImages('', this)

    Spree.addImageHandlers(productParent)

  Spree.initializeSlider('[data-selected-variant]')
  Spree.initializeProductShow('[data-selected-variant]')

  $('.quick-view').on 'click', (event) ->
    Spree.showContent(event, this)
