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
      post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'creates and saves new answer for the question to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end
      it 'creates and saves new answer for the user to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js } }.to change(@user.answers, :count).by(1)
      end
      # it 'render create template' do
      #   post :create, params: { question_id: question.id, answer: attributes_for(:answer), format: :js }
      #   expect(response).to render_template :create
      # end
    end

    context 'with invalid attributes' do
      it 'fails to save new answer to DB' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end
      it 'render create template' do
        post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question) }

    it 'assigns Answer from DB to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns Question from DB to @question' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:question)).to eq question
    end

    context 'owner' do
      it 'changes answer attributes' do
        sign_in(answer.user)
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to eq 'new body'
      end
    end

    context "other's answer" do
      let!(:other_user) { create(:user) }

      it "doesn't change answer attributes" do
        sign_in(other_user)
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'owner' do
      it 'deletes answer belonging to user' do
        sign_in(answer.user)

        expect { delete :destroy, params: { id: answer, format: :js } }.to change(answer.user.answers, :count).by(-1)
      end

      it 'removing answer from view' do
        sign_in(answer.user)
        question = answer.question

        delete :destroy, params: { id: answer, format: :js }
        expect(response).to_not have_content answer.body
      end
    end

    it "doesn't delete answer belonging to somebody else" do
      expect { delete :destroy, params: { id: answer, format: :js } }.not_to change(Answer, :count)
    end
  end

  describe 'PATCH #set_best' do
    context 'owner of the question' do
      it 'sets best answer' do
        sign_in(answer.question.user)
        patch :set_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best?).to be true
      end

      it 'changes best answer' do
        other_answer = create(:answer, question: answer.question, best: true)
        sign_in(answer.question.user)
        patch :set_best, params: { id: answer, format: :js }
        other_answer.reload
        expect(other_answer.best?).to be false
      end
    end

    it "doesn't set best answer to a question belonging to somebody else" do
      patch :set_best, params: { id: answer, format: :js }
      answer.reload
      expect(answer.best?).to be false
    end
  end
end
