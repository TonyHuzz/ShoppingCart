class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  enum cart_type: [ :buy_now, :buy_next_time ]
  # enum :cart_type => [ :buy_now, :buy_next_time ]    #兩種寫法都可以
  validates :cart_type, inclusion: { in: %w(buy_now buy_next_time), message: "%{value} is not a valid cart type" }

  def amount
    @amount = 0

    cart_items.each do |item|
      @amount += item.quantity * item.product_price
    end

    return @amount
  end
end
