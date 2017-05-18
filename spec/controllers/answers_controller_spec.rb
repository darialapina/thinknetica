require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  # describe 'GET #index' do
  #   Ответы будут выводиться на странице вопроса
  # end

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
      it 'creates and saves new answer to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer)} }.to change(Answer, :count).by(1)
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
      it 'renders new view' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer) }
        expect(response).to render_template :new
      end
    end
  end

end
