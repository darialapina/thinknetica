answers_channel = ->
  if gon.question_id
    App.answers = App.cable.subscriptions.create "AnswersChannel",
      connected: ->
        @perform 'follow', question_id: gon.question_id

      received: (data) ->
        answer = $.parseJSON(data)
        $('.answers ul.answers_list').append  JST["templates/answer"](answer)
  else
    if (App.answers)
      App.cable.subscriptions.remove(App.answers)

$(document).on('turbolinks:load', answers_channel)
$(document).on('page:load', answers_channel)
$(document).on('page:update', answers_channel)