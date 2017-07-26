require 'rails_helper'

RSpec.describe InformSubscribersJob, type: :job do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question) }

  it 'informs subscribers' do
    question.subscriptions.each { |subscription| expect(AnswersMailer).to receive(:inform_subscriber).with(subscription).and_call_original }
    InformSubscribersJob.perform_now(answer)
  end
end
