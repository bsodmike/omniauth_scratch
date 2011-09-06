class SessionsController < ApplicationController
  before_filter :handle_signed_in, :only => [:new]
  
  def new
  end

  def create      
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
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
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => "Logged out!"
  end  
end
