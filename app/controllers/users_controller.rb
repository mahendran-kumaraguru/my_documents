class UsersController < ApplicationController

	before_action :check_logged_in

  	def check_logged_in
    	if session[:user_id]
      		redirect_to documents_path
    	end
  	end

	def new
		@user = User.new
	end

	def create
	  	@user = User.new(user_params)
	  	puts @user.inspect
	  	if @user.save
	  		redirect_to login_path, :notice => "Registered Successfully"
	  	else
	  		redirect_to :back, :notice => @user.errors.full_messages.first
	  	end
	end

	private def user_params
  		params.require(:user).permit(:email, :password, :password_confirmation)
  	end
end
