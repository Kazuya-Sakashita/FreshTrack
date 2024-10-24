# app/jobs/expiration_reminder_job.rb

class ExpirationReminderJob
  include Sidekiq::Worker

  def perform
    expiring_products = Product.where('expiration_date <= ?', 7.days.from_now)

    # expiring_productsが空でない場合のみメールを送信
    return if expiring_products.empty?

    UserMailer.expiration_reminder(expiring_products).deliver_now
  end
end
