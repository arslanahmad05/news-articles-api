class UserMailer < ApplicationMailer

  def send_password_to_user(user, password)
    @user = user
    @password = password
    mail(to: user.email, subject: 'YOUR NEWS ARTICLE API PASSWORD')
  end

  def send_worker_notication(user, articles)
    @user = user
    @articles = articles
    mail(to: user.email, subject: 'New Articles Update')
  end
end
