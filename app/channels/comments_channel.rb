class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "comments_for_question_#{data['question_id']}_and_its_answers"
  end

  def unfollow
    stop_all_streams
  end
end
