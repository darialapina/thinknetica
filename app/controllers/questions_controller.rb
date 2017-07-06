class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :edit, :update]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
    @answer.attachments.build
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def new
    @question = Question.new
    @question.attachments.build
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      @question.as_json(methods: :rating)
    )
  end
end
