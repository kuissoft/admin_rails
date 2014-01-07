class Emailer < ActionMailer::Base
  default from: "jiri@remoteassistant.me"

  def authentication_email user
    @user = user
    mail to: user.email, subject: "Authentication e-mail"
  end

  def invitation_email user, invitator
    @user = user
    @invitator = invitator
    mail to: @user, subject: "Invitation e-mail from #{@invitator.name}"
  end


end
