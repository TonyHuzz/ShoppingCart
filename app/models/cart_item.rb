class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  has_one :user, through: :cart      #透過這個連結，cart_item就可以找到他的user，用於cart_items_controller的 #get_cart_item

  validates :quantity, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10 }


  def product_name
    product.try(:name) || ""
  end

  def product_price
    @price = product.try(:price)

    if !@price || @price < 0
      @price = 0
    end

    return @price
  end
end
