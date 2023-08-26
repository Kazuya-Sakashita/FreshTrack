require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:user) { create(:user) } 
  let(:product) { build(:product, user: user) }

  describe 'バリデーション' do
    it '商品名(name) 値がない場合にバリデーションエラーが発生すること' do
      product.name = nil
      product.valid?
      expect(product.errors[:name]).to include('を入力してください')
    end

    it '購入日(purchase_date) 値がない場合にバリデーションエラーが発生すること' do
      product.purchase_date = nil
      product.save
      expect(product.errors[:purchase_date]).to include('を入力してください')
    end


    it '消費期限(expiration_date)  値がない場合にバリデーションエラーが発生すること' do
      product.expiration_date = nil
      product.valid?
      expect(product.errors[:expiration_date]).to include('を入力してください')
    end

    it '通知(notify_expiration)  の値が正しくない場合にエラーが発生すること' do
      product.notify_expiration = nil
      product.valid?
      expect(product.errors[:notify_expiration]).to include('は許可されている値を使用してください')
    end
  end
end