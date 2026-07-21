class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item
  before_action :redirect_if_unpurchasable

  def index
    @order_address = OrderAddress.new
  end

  def create
    @order_address = OrderAddress.new(order_params)
    if @order_address.valid?
      pay_item
      @order_address.save
      redirect_to root_path
    else
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  # 出品者本人・売却済み商品は購入できないためトップページへ返す
  def redirect_if_unpurchasable
    redirect_to root_path if current_user.id == @item.user_id || @item.sold_out?
  end

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :house_number, :building, :phone_number)
          .merge(user_id: current_user.id, item_id: @item.id, token: params[:token])
  end

  def pay_item
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
  end
end
