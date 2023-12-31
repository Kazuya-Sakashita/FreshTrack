class ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user

    def index
      @q = current_user.products.ransack(params[:q])
      @products = @q.result(distinct: true).page(params[:page]).per(15)
      @soon_expiring_count = @products.select { |p| (p.expiration_date - Date.today).to_i < 7 }.count
    end

    def show
    end

    def new
      @product = Product.new
    end

    def create
      @product = current_user.products.build(product_params) 
      if @product.save
        redirect_to @product, notice: 'Product was successfully created.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @product.update(product_params)
        redirect_to @product, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end
  
    def destroy
      @product.destroy
      redirect_to products_url, notice: 'Product was successfully destroyed.'
    end

    def toggle_notify_expiration
      product = Product.find(params[:id])
      product.update(notify_expiration: !product.notify_expiration)
      redirect_to products_path, notice: '通知設定を更新しました。'
    end

    def test_notification
      # カレントユーザーのIDをパラメータとしてWorkerのperformメソッドをキューに追加します。
      ReminderMailerWorker.perform_async(current_user.id)

      redirect_to products_path, notice: 'テスト通知を送信しました。'
    end

    private
      def set_product
          @product = Product.find_by(id: params[:id])
        unless @product
          flash[:alert] = "プロダクトが見つかりません。"
          redirect_to root_path # または適切なパスへリダイレクト
        end
      end

      def product_params
        params.require(:product).permit(:name, :purchase_date, :expiration_date, :notify_expiration) 
      end

      def authorize_user
        return unless @product # これにより、@productがnilの場合にauthorize_userメソッドをスキップします。

        unless @product.user == current_user
          flash[:alert] = "あなたはこのページにアクセスする権限がありません。"
          redirect_to root_path # または適切なパスへリダイレクト
        end
      end
  end
