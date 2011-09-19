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
      u = User.find(current_user.id).dup # generates a new token
      cookies[:auth_token] = u.auth_token
      authentication.update_attribute(:user_id, u.id)
            
      flash[:notice] = "Successfully authenticated with #{omniauth['provider']}!"
      redirect_to authentications_url    
    # if authentication exists, sign in that user (as per Railscast)    
    elsif authentication
      flash[:notice] = "Signed in successfully."
      cookies[:auth_token] = authentication.user.auth_token
      redirect_to authentications_url
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Successfully added #{omniauth['provider']} authentication to your account."
      redirect_to authentications_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Your account has been created and you have been signed in!"
        cookies[:auth_token] = user.auth_token
        redirect_to root_url
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
