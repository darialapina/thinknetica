require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe 'autosubscribe author after create' do
    let(:question){ build(:question) }

    it 'calls subscribe_author after create' do
      expect(question).to receive(:autosubscribe_author)
      question.save
    end
    it 'creates subscription for author after question creation' do
      expect(Subscription).to receive(:create!).with({ user: question.user, question: question })
      question.save
    end
  end
end
