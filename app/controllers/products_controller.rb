class ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user
  
    def index
      @products = current_user.products.all.page(params[:page]).per(15)
      @soon_expiring_count = @products.select { |p| (p.expiration_date - Date.today).to_i < 7 }.count
      # flash[:notice] = "プロダクト一覧を表示します。" 
    end
  
    def show
    end
  
    def new
      @product = Product.new
    end
  
    def create
      @product = Product.new(product_params)
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
  