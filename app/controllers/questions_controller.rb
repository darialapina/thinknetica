class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :edit, :update]
  before_action :build_answer, only: [:show]
  before_action :build_comment, only: [:show]
  after_action :publish_question, only: [:create]

  respond_to :html

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def edit
  end

  def update
    # if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with(@question)
    # end
  end

  def destroy
    # if current_user.author_of?(@question)
      respond_with(@question.destroy!)
    # end
  end

private

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def build_comment
    @comment = @question.comments.build
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
