class SearchController < ApplicationController
  authorize_resource
  respond_to :html

  def search
    respond_with(@results = Search.find(params[:query], params[:for]))
  end
end
