class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(data)
    stop_all_streams
    stream_from "answers_to_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end