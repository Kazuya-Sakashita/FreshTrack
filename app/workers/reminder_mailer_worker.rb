class ReminderMailerWorker
  include Sidekiq::Worker

  def perform
    expiring_products = Product.includes(:user).where('expiration_date <= ?', 7.days.from_now)
    
    # ユーザーごとに製品をグループ化します。
    products_by_user = expiring_products.group_by(&:user)

    # 各ユーザーに対してメールを送信します。
    products_by_user.each do |user, products|
      UserMailer.reminder_email(user.email, products).deliver_now
    end
  end
end
