class ScheduleManager
  def self.update_schedule_for_user(user)
    schedule = user.job_schedule
    return false unless schedule&.cron.present?

    Sidekiq.set_schedule(
      "expiration_reminder_#{user.id}",
      {
        'cron'  => schedule.cron,
        'class' => 'ExpirationReminderJob',
        'args'  => [user.id]
      }
    )

    Sidekiq::Scheduler.reload_schedule!
    Rails.logger.info "スケジュールを更新: User #{user.id}, Cron: #{schedule.cron}"
    true  # 成功した場合はtrueを返す
  rescue => e
    Rails.logger.error "スケジュール更新エラー: #{e.message}"
    false  # 失敗した場合はfalseを返す
  end
end
