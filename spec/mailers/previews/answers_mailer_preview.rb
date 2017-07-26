# Preview all emails at http://localhost:3000/rails/mailers/answers_mailer
class AnswersMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answers_mailer/inform_subscriber
  def inform_subscriber(subscription)
    AnswersMailerMailer.inform_subscriber(subscription)
  end

end
