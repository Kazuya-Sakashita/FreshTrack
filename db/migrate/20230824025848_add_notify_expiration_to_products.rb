class AddNotifyExpirationToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :notify_expiration, :boolean, default: true
  end
end
