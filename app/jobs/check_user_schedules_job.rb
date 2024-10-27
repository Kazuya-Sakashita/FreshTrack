class CheckUserSchedulesJob < ApplicationJob
  queue_as :default

  def perform
    JobSchedule.find_each do |schedule|
      Sidekiq.set_schedule(
        "expiration_reminder_#{schedule.user_id}",
        {
          'cron'  => schedule.cron,
          'class' => 'ExpirationReminderJob',
          'args'  => [schedule.user_id]
        }
      )
    end

    # スケジュールを再読み込み
    Sidekiq::Scheduler.reload_schedule!
    Rails.logger.info "全てのユーザースケジュールを更新しました。"
  rescue => e
    Rails.logger.error "スケジュール更新エラー: #{e.message}"
  end
end
