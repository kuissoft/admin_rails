class Emailer < ActionMailer::Base
  default from: "admin@remoteassistant.me"

  def feedback_email feedback 
    @feedback = feedback

    @user = User.where(id: @feedback.user_id ).first if @feedback.user_id

    mail to: "project-4944826-c6516e79fe6f8eada19a7dcf@basecamp.com", subject: 'Feedback (iOS)'
  end

  def authentication_email user
    @user = user

    mail to: user.email, subject: "Pin: #{@user.validation_code}"
  end

  def invitation_email user, invitator
    @user = user
    @invitator = invitator
    mail to: @user.email, subject: "Invitation e-mail from #{@invitator.name}"
  end


end
