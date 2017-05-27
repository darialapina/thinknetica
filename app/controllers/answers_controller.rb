class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
