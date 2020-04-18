class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user

    mail to: user.email, subject: "account activation lmao"
  end

  def password_reset(user)
    @user = user

    mail to: user.email, subject: "password reset lmao"
  end
end
