class ExpirationReminderJob
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    products = user.products.where('expiration_date <= ?', 7.days.from_now)

    if products.any?
      UserMailer.expiration_reminder(user, products).deliver_now
      Rails.logger.info "メールを送信しました: #{user.email} に #{products.size} 件の通知"
    else
      Rails.logger.info "通知する製品がありません: #{user.email}"
    end
  rescue => e
    Rails.logger.error "ジョブ実行エラー: #{e.message}"
  end
end
