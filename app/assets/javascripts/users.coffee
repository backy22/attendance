$ ->
  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()


ready = ->
  dateFormat = 'yyyy/mm/dd';
  $('.datepicker').datepicker(
    dateFormat: dateFormat,
    minDate: 0
  );
$(document).ready(ready)
$(document).on('turbolinks:load', ready)
