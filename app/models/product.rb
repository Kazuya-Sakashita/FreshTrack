class Product < ApplicationRecord
  validates :name, presence: true
  validates :purchase_date, presence: true
  validates :expiration_date, presence: true

  def days_until_expiration
    (expiration_date - Date.today).to_i
  end
end
