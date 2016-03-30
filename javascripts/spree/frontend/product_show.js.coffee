Spree.ready ($) ->
  Spree.updateVariantPrice = (variant) ->
    variantPrice = variant.data('price')
    variantCostPrice = variant.data('cost')
    variantPercentageProfit = variant.data('percentage-profit')
    ($ '.price.selling').text(variantPrice) if variantPrice
    ($ '.price.cost').text(variantCostPrice) if variantCostPrice
    ($ '.price.percentage').text(variantPercentageProfit) if variantPercentageProfit

  Spree.productQuantityField = (_this) ->
    _this.value = parseInt(_this.value) if _this.value != ''
    _this.value = 1 if _this.value == 'NaN' || _this.value < 1

  Spree.productUpdateQuantityField = (_this, event) ->
    if(event.keyCode == 38)
      if _this.value == ''
        _this.value = 1
      else
        _this.value = parseInt(_this.value) + 1

    if(event.keyCode == 40)
      if _this.value == ''
        _this.value = 1
      else
        _this.value = parseInt(_this.value) - 1
    Spree.productQuantityField(_this)

  quantityField = ($ "[data-hook='product-quantity']")
  quantityField.bind 'input propertychange', (event) ->
    Spree.productQuantityField(this)
  quantityField.bind 'input keyup', (event) ->
    Spree.productUpdateQuantityField(this, event)
