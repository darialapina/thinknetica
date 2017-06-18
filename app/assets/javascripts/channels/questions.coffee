App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    if gon.question_id
      @perform 'follow', question_id: gon.question_id
    else
      @perform 'unfollow'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    answer = $.parseJSON(data)
    $('.answers ul.answers_list').append  JST["templates/answer"](answer)
    $('form#new_answer #answer_body').val('');
    # $('.answers_errors').html("<%= j render 'errors', item: @answer %>");

