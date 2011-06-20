class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    # give a user account priority over authentications; therefore, 
    # merge the authentication with the signed in account.
    if current_user && authentication
      authentication.update_attribute(:user_id, current_user.id)
      session[:user_id] = current_user.id
      flash[:notice] = "Successfully authenticated with #{omniauth['provider']}!"
      redirect_to authentications_url    
    # if authentication exists, sign in that user (as per Railscast)    
    elsif authentication
      flash[:notice] = "Signed in successfully."
      session[:user_id] = authentication.user_id
      redirect_to authentications_url
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        session[:user_id] = user.id
        redirect_to authentications_url
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to sign_up_url
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
  
  def failure
  end
end
