questionsList = $(".questions-list")

App.list_questions = App.cable.subscriptions.create "ListQuestionsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    @perform 'follow'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    questionsList.append JST["templates/question"](data)
