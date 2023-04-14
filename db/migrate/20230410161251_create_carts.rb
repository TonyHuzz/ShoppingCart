class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.belongs_to :user
      t.integer :cart_type
      t.timestamps
    end
  end
end
