class JobSchedule < ApplicationRecord
  belongs_to :user

  validate :valid_cron_format

  private

  def valid_cron_format
    Fugit::Cron.parse(cron)
  rescue StandardError
    errors.add(:cron, 'は無効なフォーマットです')
  end
end
