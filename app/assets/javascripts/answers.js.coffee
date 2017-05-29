# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  # Это наш обработчик, перенесенный сюда из docuement.ready ($ ->)
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('input.set-best-answer').on 'change',  ->
    answer_id = $(this).data('answerId')
    question_id = $(this).data('questionId')
    $.ajax
      type: "PATCH"
      url: "/answers/" + answer_id + "/set_best"
      dataType: "json"
      data:
        id: answer_id
        question_id: question_id
      success: (data) ->
        $('.answers p.notice').html(data.message)
        $('li#answer_' + answer_id).parent().prepend($('li#answer_' + answer_id))
      error: ->
        $('.answers p.notice').html('Something is wrong.')

  #  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
