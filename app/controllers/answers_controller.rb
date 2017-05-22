class AnswersController < ApplicationController
  before_action :authenticate_user! #, except: [:index, :show]
  before_action :load_question #, only: [:new, :create]

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user_id: current_user.id))

    if @answer.save
      flash[:notice] = 'Your answer was successfully created.'
      redirect_to question_path(@question)
    else
      flash[:alert] = 'Your answer has an error.'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was successfully created.'
    end
    redirect_to @answer.question
  end

private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
