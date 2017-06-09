require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  describe 'set best to instance' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:other_answer) { create(:answer, question: question, best: true) }

    it 'should set best true to instance' do
      answer.set_best

      expect(answer).to be_best
    end

    it 'should set best false to all other answers for the question' do
      answer.set_best
      other_answer.reload

      expect(other_answer).to_not be_best
    end
  end

  describe 'order answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let!(:other_answer) { create(:answer, question: question, best: true) }

    it 'should place best answer first' do
      expect(question.answers.first.id).to eq other_answer.id
    end
  end

  it 'should count total rate for answer' do
    answer = create(:answer)
    votes = create_list(:vote, 3, votable: answer, value: -1)

    expect(answer.rating).to eq -3
  end

  def has_vote_by?(user)
    self.votes.exists?(user_id: user.id)
  end

  describe 'check if answer has a vote by user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:answer) { create(:answer) }
    let!(:vote) { create(:vote, votable: answer, user: user) }

    it 'should return true if answer has a vote by user' do
      expect(answer.has_vote_by?(user)).to eq true
    end

    it "should return false if answer doesn't have a vote by user" do
      expect(answer.has_vote_by?(other_user)).to eq false
    end
  end
end
