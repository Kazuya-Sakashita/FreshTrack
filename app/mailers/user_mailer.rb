class UserMailer < ApplicationMailer
  def expiration_reminder(user, products)
    @user = user
    @products = products
    mail(to: @user.email, subject: '製品の有効期限通知')
  end
end
