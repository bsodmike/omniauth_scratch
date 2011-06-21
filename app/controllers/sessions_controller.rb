class SessionsController < ApplicationController
  before_filter :handle_signed_in, :only => [:new]
  
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  rescue BCrypt::Errors::InvalidSalt    
    flash[:error] = "Invalid password! You need to create an account."
    redirect_to sign_up_path
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end  
end
