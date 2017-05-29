class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :edit, :update]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question was successfully created.'
      redirect_to @question
    else
      flash[:alert] = 'Your question has errors.'
      render :new
    end
  end

  def edit
  end

  def update
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:notice] = 'Your question was successfully updated.'
        redirect_to @question
      else
        flash[:alert] = 'Your question has errors.'
        render :edit
      end
    else
      redirect_to @question
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy!
      flash[:notice] = 'Your question was successfully deleted.'
    end
    redirect_to questions_path
  end

private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
