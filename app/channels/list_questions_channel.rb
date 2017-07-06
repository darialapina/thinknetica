class ListQuestionsChannel < ApplicationCable::Channel
  def follow
    stream_from "questions"
  end

  def unfollow
    stop_all_streams
  end
end
