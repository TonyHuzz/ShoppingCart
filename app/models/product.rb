class Product < ApplicationRecord
  mount_uploader :image_url, ImageUploader

  belongs_to :subcategory
  has_one :category, through: :subcategory

  has_many :cart_items
  has_many :order_items

  validates :name, :description, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
