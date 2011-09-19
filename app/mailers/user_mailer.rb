class UserMailer < ActionMailer::Base
  default_url_options[:host] = "localhost"
  default :from => "from@example.com"

  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "Password Reset")
  end
end
