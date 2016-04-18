Spree.ready ($) ->

  Spree.searchProducts = (_this) ->
    $("[data-show-products='search']").text('')
    return if _this.value.trim().length == 0
    $(_this).addClass('active')
    $('.load-results-keypress').removeClass('hidden')
    $.ajax({
      url: $("[data-search-path]").data('search-path'),
      data: { keywords: _this.value, taxon: $("[name='taxon']").val() },
      dataType: 'SCRIPT',
    });

  Spree.intializeInfiniteSearch = () ->
    $("[data-show-products='search']").infinitePages
      debug: true
      buffer: 200
      context: '#search-form-modal'
      loading: ->
        $('.load-results').removeClass('hidden')
      success: ->
        $('.load-results').addClass('hidden')
      error: ->
        $('.load-results').addClass('hidden')

  Spree.selectTaxonFromSelect = (_this) ->
    $("[data-taxon-id]").removeClass('active')
    $(_this).addClass('active')
    $("[name='taxon']").find("[value='" + $(_this).data('taxon-id') + "']")[0].selected = true

  $("[data-search]").on 'focusin', (event) ->
    $("[data-search-links='quick']").addClass('quick-hide')

  $("[data-search]").on 'focusout', (event) ->
    $("[data-search-links='quick']").removeClass('quick-hide') if this.value.trim().length == 0

  $("[data-search]").on 'input', (event) ->
    $('.no-results-found').addClass('hidden')
    doneTypingInterval = 1000
    clearTimeout(@typingTimer);
    @typingTimer = setTimeout (->
      Spree.searchProducts($("[data-search]")[0])
    ), doneTypingInterval

  $("[data-taxon-id]").on 'click', (event) ->
    $('.no-results-found').addClass('hidden')
    Spree.selectTaxonFromSelect(this)
    Spree.searchProducts($("[data-search]")[0])
