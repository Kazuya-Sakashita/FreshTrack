class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user

  def index
    @q = current_user.products.ransack(params[:q])
    @products = @q.result(distinct: true).page(params[:page]).per(15)
    @soon_expiring_count = @products.select { |p| (p.expiration_date - Time.zone.today).to_i < 7 }.count
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = current_user.products.build(product_params)
    if @product.save
      redirect_to @product, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: t('.success')
  end

  def toggle_notify_expiration
    product = Product.find(params[:id])
    product.update(notify_expiration: !product.notify_expiration)
    redirect_to products_path, notice: t('products.notifications.updated')
  end

  def test_notification
    # カレントユーザーのIDをパラメータとしてWorkerのperformメソッドをキューに追加します。
    ReminderMailerWorker.perform_async(current_user.id)

    redirect_to products_path, notice: t('products.notifications.sent')
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:alert] = t('products.errors.not_found')
    redirect_to root_path # または適切なパスへリダイレクト
  end

  def product_params
    params.require(:product).permit(:name, :purchase_date, :expiration_date, :notify_expiration)
  end

  def authorize_user
    return unless @product # これにより、@productがnilの場合にauthorize_userメソッドをスキップします。

    return if @product.user == current_user

    flash[:alert] = t('products.errors.unauthorized')
    redirect_to root_path # または適切なパスへリダイレクト
  end
end
