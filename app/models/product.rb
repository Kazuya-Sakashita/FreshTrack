class Product < ApplicationRecord
  validates :name, presence: true
  validates :purchase_date, presence: true
  validates :expiration_date, presence: true
  validates :notify_expiration, inclusion: { in: [true, false] }

  def days_until_expiration
    (expiration_date - Time.zone.today).to_i
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name purchase_date expiration_date] # 検索を許可したい属性のみをこの配列に追加
  end

  belongs_to :user
end
