# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


5.times do |user_number|
  # ユーザーの作成
  user = User.create!(
    email: "user#{user_number + 1}@example.com",
    password: "password", # Deviseを使用している場合
    # その他必要な属性
  )

  # このユーザーに対して10個の製品を作成
  10.times do |product_number|
    Product.create!(
      name: "Product #{product_number + 1} for User #{user_number + 1}",
      purchase_date: Date.today - (product_number + 1).days,
      expiration_date: Date.today + (product_number + 1).months,
      user_id: user.id
    )
  end
end
