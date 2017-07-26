class InformSubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.each do |subscription|
      AnswersMailer.inform_subscriber(subscription).deliver_later
    end
  end
end
