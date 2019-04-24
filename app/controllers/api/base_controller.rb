class Api::BaseController < ApplicationController
  # Skips some default Rails controller behaviors
  protect_from_forgery with: :null_session
  # API will only respond with JSON
  respond_to :json	

  def render_message status,message
    render :json => { :response => {:responseStatus => status, :responseMessage => message} }
  end
  
  # find current user for api
  def find_user
    if request.headers[:AUTHTOKEN].present?
      @current_user = User.find_by(access_token: request.headers[:AUTHTOKEN])
      unless @current_user
        return render_message false,"Sorry! You are not an authenticated user."
      end
    else
      render_message false, "Missing authentication token!."
    end
  end
end
