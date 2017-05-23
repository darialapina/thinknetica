require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  sign_in_user

  describe 'GET #new' do
    before do
      get :new, params: { question_id: question.id }
    end

    it 'assigns Question from DB to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'assigns Question from DB to @question' do
      post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'creates and saves new answer for the question to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer)} }.to change(question.answers, :count).by(1)
      end
      it 'creates and saves new answer for the user to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer)} }.to change(@user.answers, :count).by(1)
      end
      it 'redirects to question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'fails to save new answer to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer)} }.to_not change(Answer, :count)
      end
      it 'renders show question view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'owner' do
      it 'deletes answer belonging to user' do
        sign_in(answer.user)

        expect { delete :destroy, params: { id: answer, question_id: answer.question_id } }.to change(answer.user.answers, :count).by(-1)
      end

      it 'redirects to question page' do
        sign_in(answer.user)
        question = answer.question

        delete :destroy, params: { id: answer, question_id: answer.question_id }
        expect(response).to redirect_to question_path(question)
      end
    end

    it "doesn't delete answer belonging to somebody else" do
      expect { delete :destroy, params: { id: answer, question_id: answer.question_id } }.not_to change(Answer, :count)
    end
  end
end
