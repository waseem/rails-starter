class UserMailer < AbstractMailer
  default from: '"Application" <no-reply@application.com>'

  def password_reset(user_id)
    @user = User.find(user_id)

    mail to: @user.email, subject: "Password Reset"
  end

  def email_confirmation(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "You're almost there! Please confirm your email"
  end
end
