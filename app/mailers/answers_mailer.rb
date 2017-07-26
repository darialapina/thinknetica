class AnswersMailer < ApplicationMailer

  def inform_subscriber(subscription)
    @subscription = subscription

    mail to: subscription.user.email
  end
end
