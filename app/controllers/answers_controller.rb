class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:update, :destroy, :set_best]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    if current_user.author_of?(@question)
      @answer.set_best

      render json: { message: "You've set the best answer" }
    else
      render json: { message: "You're not allowed to set the best answer for this question" }
    end
  end

private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
