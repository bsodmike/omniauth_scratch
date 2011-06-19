class AuthenticationsController < ApplicationController
  def index
    @authentications = Authentication.all
  end

  def create
    auth = request.env['omniauth.auth']
    current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
    flash[:notice] = "Authentication successful"
    redirect_to authentications_url
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy
    redirect_to authentications_url, :notice => "Successfully destroyed authentication."
  end
end
