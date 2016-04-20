Spree.ready ($) ->
  if ($ 'form#update-cart').is('*')
    ($ 'form#update-cart a.delete').show().one 'click', ->
      ($ this).parents('.line-item').first().find('input.line_item_quantity').val 0
      ($ this).parents('form').first().submit()
      false

  ($ 'form#update-cart').submit ->
    ($ 'form#update-cart #update-button').attr('disabled', true)

  Spree.cleanErrorField = (_this) ->
    $(_this).closest('.form-group').removeClass('has-error').find('.help-block').remove()

  Spree.updateStateLockVersion = (stateLockVersion) ->
    $("[name='order[state_lock_version]']").val(stateLockVersion)

  Spree.displayErrors = (errors_hash, order_state) ->
    errors_hash = JSON.parse(errors_hash)
    if order_state == 'payment'
      $("[data-behaviour='payment-errors'").text('')
      $.each errors_hash['payments.Credit Card'], (index, error_message) ->
        $("[data-behaviour='payment-errors'").append(error_message + "<br>")
    else
      form = $('#checkout_form_' + order_state)
      $('.form-group').removeClass('has-error').find('.help-block').remove()
      $.each errors_hash, (field, messages) ->
        input = form.find('input, select, textarea').filter(->
          name = $(this).attr('name')
          if 'order[' + field.replace('.', '_attributes][') + ']' == name
            $(this).closest('.form-group').addClass('has-error').append('<span class="help-block">' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>')
          return
        )

  Spree.hideCheckoutProgress = (_this) ->
    $('.collapse').removeClass('in')

  Spree.showCheckoutProgress = (order_state) ->
    $('.collapse').addClass("[data-checkout-progress=" + order_state + "]")

  $('input').on 'input', () ->
    Spree.cleanErrorField(this)

Spree.fetch_cart = ->
  $.ajax
    url: Spree.pathFor("cart_link"),
    success: (data) ->
      $('#link-to-cart').html data

