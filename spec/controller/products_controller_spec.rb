require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product, user: user) }
  
  describe "GET #index" do
    context "認証されたユーザーとして" do
      before do
        sign_in user
        get :index
      end

      it "正常にレスポンスを返す" do
        expect(response).to be_successful
      end

      it "名前で検索できること" do
        product1 = FactoryBot.create(:product, name: "Apple", user: user)
        product2 = FactoryBot.create(:product, name: "Banana", user: user)
        get :index, params: { q: { name_cont: "Apple" } }
        expect(assigns(:products)).to contain_exactly(product1)
        expect(assigns(:products)).not_to include(product2)
      end
    end

    context "ゲストとして" do
      before do
        get :index
      end

      it "サインインページにリダイレクトする" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #show" do
    context "商品が存在する場合" do
      before do
        sign_in user  # Deviseのヘルパーメソッドを使用してユーザーをサインインさせる
        get :show, params: { id: product.id }
      end

      it "正しいレスポンスが返されること" do
        expect(response).to have_http_status(:success)
      end

      it "指定した商品の詳細ページが表示されること" do
        expect(response).to render_template 'products/show'
      end
    end

    context "商品が存在しない場合" do
      before do
        sign_in user
        get :show, params: { id: "invalid_id" }
      end

      it "ルートページにリダイレクトすること" do
        expect(response).to redirect_to(root_path)
      end

      it "アラートメッセージが表示されること" do
        expect(flash[:alert]).to eq("プロダクトが見つかりません。")
      end
    end
  end

  describe "GET #new" do
  # ユーザーが認証されていない場合のコンテキスト
    context 'ユーザーが認証されていない場合' do
      # ログインページにリダイレクトされることを期待するテスト
      it 'ログインページにリダイレクトする' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    # ユーザーが認証されている場合のコンテキスト
    context 'ユーザーが認証されている場合' do
      let(:user) { create(:user) }  # 仮定: UserモデルのFactoryが設定されている

      before do
        sign_in user  # Deviseのヘルパーメソッド
      end

      # newテンプレートがレンダリングされることを期待するテスト
      it 'newテンプレートをレンダリングする' do
        get :new
        expect(response).to render_template(:new)
      end

      # @product変数に新しいProductオブジェクトが割り当てられることを期待するテスト
      it '@productに新しいProductが割り当てられる' do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end
    end
  end

  describe "POST #create" do
    context "有効なパラメータの場合" do
      it "商品が正常に作成されること" do
        # テストの実装
      end
    end

    context "無効なパラメータの場合" do
      it "商品の作成に失敗し、エラーメッセージが表示されること" do
        # テストの実装
      end
    end
  end

  describe "PATCH #toggle_notify_expiration" do
    context "認証されたユーザーとして" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      context "notify_expirationがtrueの場合" do
        let(:product) { create(:product, user: user, notify_expiration: true) }

        it "notify_expirationをfalseに切り替える" do
          expect {
            patch :toggle_notify_expiration, params: { id: product.id }
          }.to change { product.reload.notify_expiration }.from(true).to(false)
        end
      end

      context "notify_expirationがfalseの場合" do
        let(:product) { create(:product, user: user, notify_expiration: false) }

        it "notify_expirationをtrueに切り替える" do
          expect {
            patch :toggle_notify_expiration, params: { id: product.id }
          }.to change { product.reload.notify_expiration }.from(false).to(true)
        end
      end
    end
  end
end
