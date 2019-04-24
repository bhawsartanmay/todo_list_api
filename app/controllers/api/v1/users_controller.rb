class Api::V1::UsersController < ApplicationController

	#Method For User Sign up
	def sign_up
    @user = User.find_by(email: params[:email].try(:downcase))
    return render_message false, 402, "User already exists." if @user.present?
    @user = User.new(user_params)
    if @user.save
	    render json: @user, adapter: :json, meta: {responseStatus: true, responseCode: 200, responseMessage: "Signup successfully." }, meta_key: 'response'
    else
    	render_message false, 402, @user.errors.full_messages.first
    end
  end

  #Method For User Sign in
	def create
		@user = User.find_by(user_name: params[:email].try(:downcase))
    return render_message false, 402, "Incorrect email or password." unless @user && @user.valid_password?(params[:password])
		sign_in(@user, store: false)
    @user.generate_token
    device = @user.devices.create(device_params)
    render json: @user, adapter: :json, meta: {responseStatus: true, responseCode: 200, responseMessage: "Login successfully." }, meta_key: 'response'
	end

	private

  def user_params
    params.permit(:email, :name,:password)
  end

  def device_params
    params.require(:device).permit(:device_type, :device_token)
  end
end
