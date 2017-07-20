class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :load_question
  after_action :publish_answer, only: [:create]

  authorize_resource

  respond_to :js
  respond_to :json, only: [:set_best]

  def new
    respond_with(@answer = @question.answers.build)
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    respond_with(@answer.set_best)
  end

private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = @answer ? @answer.question : Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "answers_to_question_#{@answer.question_id}",
      ApplicationController.render(partial: 'answers/answer', formats: :json, locals: { answer: @answer })
    )
  end
end
