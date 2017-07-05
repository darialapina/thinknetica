require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question, user: create(:user)) }

    context 'with valid attributes' do
      it 'creates and saves a new comment to a question to DB' do
        expect { post :create, params: { comment: attributes_for(:comment).merge( commentable_type: 'Question', commentable_id: question.id ), format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'creates and saves a new comment to an answer to DB' do
        expect { post :create, params: { comment: attributes_for(:comment).merge( commentable_type: 'Answer', commentable_id: answer.id ), format: :js } }.to change(answer.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'fails to save a new comment to a question to DB' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment).merge( commentable_type: 'Question', commentable_id: question.id ), format: :js } }.to_not change(question.comments, :count)
      end
      it 'fails to save a new comment to an answer to DB' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment).merge( commentable_type: 'Answer', commentable_id: answer.id ), format: :js } }.to_not change(answer.comments, :count)
      end
    end
  end
end
