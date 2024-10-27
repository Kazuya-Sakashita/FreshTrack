# config/initializers/sidekiq.rb

redis_config = { url: 'redis://redis:6379/0' }

# Sidekiq サーバー側の設定
Sidekiq.configure_server do |config|
  config.redis = redis_config

  config.on(:startup) do
    begin
      schedules = load_schedule_from_db

      if schedules.any?
        Sidekiq.schedule = schedules
        Sidekiq::Scheduler.reload_schedule!
        Rails.logger.info "スケジュールが正常にロードされました: #{schedules.keys.join(', ')}"
      else
        Rails.logger.warn "スケジュールが見つかりません。"
      end
    rescue => e
      Rails.logger.error "スケジュールのロードエラー: #{e.message}"
      raise e  # エラーを再度投げてSidekiqの動作確認を容易にする
    end
  end
end

# Sidekiq クライアント側の設定
Sidekiq.configure_client do |config|
  config.redis = redis_config
end

# スケジュールをデータベースからロードするヘルパーメソッド
def load_schedule_from_db
  schedules = JobSchedule.all.each_with_object({}) do |schedule, hash|
    hash["expiration_reminder_#{schedule.user_id}"] = {
      'cron'  => schedule.cron,
      'class' => 'ExpirationReminderJob',
      'args'  => [schedule.user_id]
    }
  end

  Rails.logger.info "ロードしたスケジュール: #{schedules.inspect}"
  schedules.presence || {}
end
