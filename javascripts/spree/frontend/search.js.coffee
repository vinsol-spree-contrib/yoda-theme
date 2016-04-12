Spree.ready ($) ->

  Spree.searchProducts = (_this) ->
    $("[data-show-products='search']").text('')
    return if _this.value.trim().length == 0
    $(_this).addClass('active')
    $.ajax({
      url: $("[data-search-path]").data('search-path'),
      data: { keywords: _this.value },
      dataType: 'SCRIPT',
    });

  $("[data-search]").on 'input', (event) ->
    Spree.searchProducts(this)

  Spree.intializeInfiniteSearch = () ->
    $("#products_infinite").infinitePages
      debug: true
      buffer: 200
      context: '#search-form-modal'
