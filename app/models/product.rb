class Product < ApplicationRecord
  validates :name, presence: true
  validates :purchase_date, presence: true
  validates :expiration_date, presence: true
end
