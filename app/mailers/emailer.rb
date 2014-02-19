class Emailer < ActionMailer::Base
  default from: "admin@remoteassistant.me"

  def feedback_email feedback 
    @feedback = feedback

    @user = User.where(id: @feedback.user_id ).first if @feedback.user_id

    mail to: "project-4944826-c6516e79fe6f8eada19a7dcf@basecamp.com", subject: 'Feedback (iOS)'
  end

  def authentication_email user, device = ""
    @user = user
    @device = device
    # Fix for API
    subject = "Pin: #{@user.validation_code}"  if @device.blank?
    subject = "Pin: #{@device.verification_code}"  if @device

    mail to: user.email, subject: subject
  end

  def invitation_email user, invitator
    @user = user
    @invitator = invitator
    mail to: @user.email, subject: "Invitation e-mail from #{@invitator.name}"
  end


end
