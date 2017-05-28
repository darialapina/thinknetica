require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe 'set is_best to instance' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:other_answer) { create(:answer, question: question, is_best: true) }

    it 'should set is_best true to instance' do
      answer.set_best

      expect(answer.is_best?).to eq true
    end

    it 'should set is_best false to all other answers for the question' do
      answer.set_best
      other_answer.reload

      expect(other_answer.is_best?).to eq false
    end
  end
end
