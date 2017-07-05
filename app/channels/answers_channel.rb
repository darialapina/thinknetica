class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "answers_to_question_#{data['question_id']}"
  end

  def unfollow
    stop_all_streams
  end
end