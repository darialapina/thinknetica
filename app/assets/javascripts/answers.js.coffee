# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
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
      url: "/questions/" + question_id + "/answers/" + answer_id + "/set_best"
      dataType: "json"
      data:
        _method: "PUT"
        id: answer_id
        question_id: question_id
      success: (data) ->
        $('.answers p.notice').html(data.message)
        $('li#answer_' + answer_id).parent().prepend($('li#answer_' + answer_id))
      error: ->
        $('.answers p.notice').html('Something is wrong.')