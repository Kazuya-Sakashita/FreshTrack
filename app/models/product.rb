class Product < ApplicationRecord
  validates :name, presence: true
  validates :purchase_date, presence: true
  validates :expiration_date, presence: true
  validates :notify_expiration, inclusion: { in: [true, false] }

  def days_until_expiration
    (expiration_date - Date.today).to_i
  end

  belongs_to :user
end
