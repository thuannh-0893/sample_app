class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.a_a_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("mailers.user_mailer.p_r_subject")
  end
end
