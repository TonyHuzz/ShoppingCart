class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :products

  validates :name, presence: true

  def name_with_category
    "#{category.try(:name)} / #{name}"           #後面的name是subcategory資料表欄位name
  end
end
