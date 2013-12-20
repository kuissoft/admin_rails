class Emailer < ActionMailer::Base
  default from: "authentication@remoteassistant.me"

  def authentication_email user
    @user = user
    mail to: user.email, subject: "Authentication e-mail"
  end
end
