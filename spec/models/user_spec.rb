require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    context 'email' do
      it 'メールアドレスがなければ無効であること' do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors[:email]).to include('入力されていません。')
      end

      it '重複したメールアドレスなら無効な状態であること' do
        user = create(:user, email: 'test@example.com')
        duplicated_user = build(:user, email: 'test@example.com')
        duplicated_user.valid?
        expect(duplicated_user.errors[:email]).to include('重複しています。')
      end
    end

    context 'email' do
      it 'パスワードが６文字であれば有効なこと' do
        user = build(:user, password: 'a' * 6, password_confirmation: 'a' * 6)
        expect(user).to be_valid
      end

      it 'パスワードが６文字に満たない場合はバリデーションエラー発生すること' do
        user = build(:user, password: 'a' * 5)
        user.valid?
        expect(user.errors[:password]).to include('文字数が足りていません。')
      end
    end
  end
end
