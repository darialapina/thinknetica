# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answers').on 'change', 'input.set-best-answer', (e) ->
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

$(document).on('turbolinks:load', ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
