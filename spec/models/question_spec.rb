require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }

  it 'should count total rate for question' do
    question = create(:question)
    votes = create_list(:vote, 3, votable: question, value: 1)

    expect(question.rating).to eq 3
  end

  describe 'check if question has a vote by user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question) }
    let!(:vote) { create(:vote, votable: question, user: user) }

    it 'should return true if question has a vote by user' do
      expect(question.has_vote_by?(user)).to eq true
    end

    it "should return false if question doesn't have a vote by user" do
      expect(question.has_vote_by?(other_user)).to eq false
    end
  end
end
