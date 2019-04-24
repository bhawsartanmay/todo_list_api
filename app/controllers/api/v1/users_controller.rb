class Api::V1::UsersController < Api::BaseController
	#Method For User Sign up
	def signup
		user_exist = User.find_by(email: params[:email])
		if !user_exist.present?
			@user = User.new(user_params)
			if @user.save
				render_message true, "User Signed Up Succesfully"
			else
				render_message false, "Sign up Failed"
			end
		else
			render_message false, "Email Already Exist"
		end	
	end

#Method For User Sign in
	def create
		@user = User.where(email: params[:user][:email].try(:downcase))
    return render_message false, "Incorrect email or password." unless @user && @user.valid_password?(params[:user][:password])
		sign_in(@user, store: false)
    @user.generate_token
    device = @user.devices.create(device_params)
    render json: @user, adapter: :json, :meta => {:responseStatus => true, :responseMessage => "Login successfully." }, :meta_key => 'response'
	end
	private

  def user_params
    params.permit(:email, :name,:password)
  end
end
