class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :user_signed_in?
  
  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end  

    def user_signed_in?
      return 1 if current_user 
    end
    
    def handle_signed_in
      if user_signed_in?
        flash[:alert] = "You are already signed in"
        redirect_to root_url # halts request cycle
      end
    end    
end
