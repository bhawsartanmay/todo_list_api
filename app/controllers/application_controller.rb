class ApplicationController < ActionController::Base
	# Skips some default Rails controller behaviors
  protect_from_forgery with: :null_session
  # API will only respond with JSON
  respond_to :json	
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, :with => :render_bad_request_parameters

  def render_message status, http_code, message
    render json: { response: {responseStatus: status, responseCode: http_code, responseMessage: message} }
  end
  
  # find current user for api
  def find_user
    if request.headers[:AUTHTOKEN].present?
      @current_user = User.find_by(access_token: request.headers[:AUTHTOKEN])
      unless @current_user
        return render_message false, 402, "Sorry! You are not an authenticated user."
      end
    else
      render_message false, 402, "Missing authentication token!."
    end
  end
    
  # rescue for record not found
  def record_not_found(e = nil)
    message = e.try(:message) || "Resource is not exists or removed."
    render_message false, 402, message
  end

  # rescue for missing parameter
  def render_bad_request_parameters(e = nil)
    message = e.try(:message) || 'Bad parameters!'
    render_message false, 402, message
  end
end
