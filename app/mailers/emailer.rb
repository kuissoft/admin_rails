class Emailer < ActionMailer::Base
  default from: "jiri@remoteassistant.me"

  def authentication_email user
    @user = user
    mail to: user.email, subject: "Authentication e-mail"
  end
end
