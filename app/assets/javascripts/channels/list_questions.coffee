questions_list_channel = ->
  questionsList = $(".questions-list")

  if (questionsList.length)
    App.list_questions = App.cable.subscriptions.create "ListQuestionsChannel",
      connected: ->
        @perform 'follow'

      received: (data) ->
        questionsList.append JST["templates/question"](data)
  else
    if (App.list_questions)
      App.cable.subscriptions.remove(App.list_questions)

$(document).on('turbolinks:load', questions_list_channel)
$(document).on('page:load', questions_list_channel)
$(document).on('page:update', questions_list_channel)
