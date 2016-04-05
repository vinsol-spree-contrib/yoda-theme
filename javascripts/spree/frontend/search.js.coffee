Spree.ready ($) ->

  Spree.searchProducts = (_this) ->
    $.ajax({
      url: $("[data-search-path]").data('search-path'),
      data: { keywords: _this.value },
      dataType: 'SCRIPT',
    });

  $("[data-search]").on 'input', (event) ->
    Spree.searchProducts(this)
