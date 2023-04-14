class PaymentsController < ApplicationController
  before_action :get_order

  def index

  end


  private

  def get_order
    @order = Order.not_paid.find_by(id: params[:order_id], user: current_user)
    if !@order
      flash[:notice] = "沒有這個訂單"
      redirect_to root_path
      return
    end
  end

end
