class Category < ApplicationRecord
  has_many :subcategories
  has_many :products, through: :subcategories

  validates :name, :description, presence: true

  mount_uploader :image_url, ImageUploader

end
