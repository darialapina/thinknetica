class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  respond_to :json

  def destroy
    # if current_user.author_of?(@attachment.attachable)
      respond_with(@attachment.destroy)
    # end
  end

private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:id, :file, :_destroy)
  end
end
