class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.date :purchase_date
      t.date :expiration_date

      t.timestamps
    end
  end
end
