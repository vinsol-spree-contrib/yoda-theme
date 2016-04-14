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

  $("[data-search]").on 'focusin', (event) ->
    $("[data-search-links='quick']").addClass('quick-hide')

  $("[data-search]").on 'focusout', (event) ->
    $("[data-search-links='quick']").removeClass('quick-hide') if this.value.trim().length == 0

  $("[data-search]").on 'input', (event) ->
    doneTypingInterval = 1000
    clearTimeout(@typingTimer);
    @typingTimer = setTimeout (->
      Spree.searchProducts($("[data-search]")[0])
    ), doneTypingInterval

  Spree.intializeInfiniteSearch = () ->
    $("#products_infinite").infinitePages
      debug: true
      buffer: 200
      context: '#search-form-modal'
      loading: ->
        $('.load-results').removeClass('hidden')
      success: ->
        $('.load-results').addClass('hidden')
      error: ->
        $('.load-results').addClass('hidden')
