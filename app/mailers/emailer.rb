class Emailer < ActionMailer::Base
  default from: "noreplay@remoteassistant.me"

  def feedback_email feedback 
    @feedback = feedback

    @user = User.where(id: @feedback.user_id ).first if @feedback.user_id

    mail to: "project-4944826-c6516e79fe6f8eada19a7dcf@basecamp.com", subject: 'Feedback (iOS)'
  end

  def authentication_email user, device
    @user = user
    @device = device

    mail to: user.email, subject: "Pin: #{@device.verification_code}"
  end

  def invitation_email user, invitator, device
    @user = user
    @invitator = invitator
    @device = device
    mail to: @user.email, subject: "Invitation e-mail from #{@invitator.name}"
  end

  def reset_password_email user, new_password
    @user = user
    @new_password = new_password

    mail to: @user.email, subject: "Reset user password"
  end

end
