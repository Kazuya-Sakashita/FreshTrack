class ReminderMailerWorker
  include Sidekiq::Worker

  def perform(user_id = nil)
    Rails.logger.info "ReminderMailerWorker is performing its job!"
    
    if user_id
      user = User.find(user_id)
      expiring_products = user.products.where('expiration_date <= ?', 7.days.from_now).where(notify_expiration: true)
      UserMailer.reminder_email(user.email, expiring_products).deliver_now
    else
      # 以前のロジック
      expiring_products = Product.includes(:user).where('expiration_date <= ?', 7.days.from_now).where(notify_expiration: true)
      products_by_user = expiring_products.group_by(&:user)
      products_by_user.each do |user, products|
        UserMailer.reminder_email(user.email, products).deliver_now
      end
    end
  end
end
