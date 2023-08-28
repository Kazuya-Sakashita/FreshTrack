require 'rails_helper'

RSpec.describe ReminderMailerWorker do
  before do
    Sidekiq::Testing.inline!
    ActionMailer::Base.deliveries.clear
  end

  describe 'ReminderMailerWorker' do
    context '複数名に単数商品の場合' do
      it "メールが送信されること" do
        notification_emails = 3
        create_list(:product, notification_emails, expiration_date: 5.days.from_now, notify_expiration: true)
        expect { ReminderMailerWorker.perform_async }.to change { ActionMailer::Base.deliveries.size }.by(notification_emails)
      end
    end

    context '複数名に複数商品の場合' do
      let!(:users) do
        3.times.map do
          user = FactoryBot.create(:user)
          FactoryBot.create_list(:product, 3, user: user, expiration_date: 6.days.from_now, notify_expiration: true)
          user
        end
      end

      it "各ユーザーにメールが送信されること" do
        expect { ReminderMailerWorker.perform_async }.to change { ActionMailer::Base.deliveries.size }.by(3)
      end

      it "各ユーザーのメールには関連する商品情報のみが含まれていること" do
        ReminderMailerWorker.perform_async
        ActionMailer::Base.deliveries.each do |delivery|
          user = users.find { |u| u.email == delivery.to[0] }
          user_products = Product.where(user: user)
          user_products.each do |product|
            expect(delivery.body.encoded).to include(product.name)
          end
        end
      end
    end

    context '期限が近くない商品の場合' do
      it "メールは送信されない" do
        create(:product, expiration_date: 8.days.from_now, notify_expiration: true)
        create(:product, expiration_date: 5.days.from_now, notify_expiration: false)
        expect { ReminderMailerWorker.perform_async }.not_to change { ActionMailer::Base.deliveries.size }
      end
    end
  end
end