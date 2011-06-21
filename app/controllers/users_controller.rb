class UsersController < ApplicationController
  before_filter :handle_signed_in, :only => [:new]
  
  def new
    @user = User.new
    apply_omniauth_and_check_validations
  end
  
  def create
    @user = User.new(params[:user])
    apply_omniauth_and_check_validations
    if @user.save
      session[:omniauth] = nil unless @user.new_record? # once saved clear :omniauth
      session[:user_id] = @user.id # signin the new user
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
  
  private
    def apply_omniauth_and_check_validations
      if session[:omniauth]
        @user.apply_omniauth(session[:omniauth])
        @user.valid?
      end
    end
end
