class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :address, presence: true
  validates :phone, format: { with: /\A\d{10}\z/, message: "只允許台灣手機號碼" }
  validates :is_admin, inclusion: { in: [true, false] }

  has_many :carts, dependent: :destroy         #刪除使用者時，該使用者的購物車也會一同被刪除
  has_many :orders, dependent: :nullify        #刪除使用者時，該使用者的訂單裡面的使用者ID會變NULL

  after_create :create_carts


  def buy_now_cart
    carts.buy_now.first
  end

  def buy_now_cart_items
    buy_now_cart.cart_items
  end

  def buy_next_time_cart
    carts.buy_next_time.first
  end

  def buy_next_time_cart_items
    buy_next_time_cart.cart_items
  end

  private

  def create_carts
    if carts.blank?
      Cart.buy_now.create(user: self)
      Cart.buy_next_time.create(user: self)
    end
  end
end
