class SessionController < ApplicationController
  before_action :check_logged_in, :only => [:new]

  def check_logged_in
    if session[:user_id]
      redirect_to documents_path
    end
  end

  def new
  end

  def create
  	user = User.authenticate(params[:email], params[:password])
  	if user
  		session[:user_id] = user.id
  		redirect_to documents_path, :notice => "Logged in Successfully"
  	else
  		redirect_to :back, :notice => "Email or Password is incorrect"
  	end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, :notice => "Signed Out Successfully"
  end
end
