# メール送信のためのメソッドを修正します。
class UserMailer < ApplicationMailer
  def reminder_email(email, products)
    @products = products # インスタンス変数として製品の配列を設定
    mail(to: email, subject: t('user_mailer.products_expiring_soon'))
  end
end
