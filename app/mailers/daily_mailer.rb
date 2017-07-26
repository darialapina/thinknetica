class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where('updated_at > ?', 1.day.ago)

    mail to: user.email
  end
end
