class AddUserInfoInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :phone, :string
    add_column :users, :address, :string
    add_column :users, :is_admin, :boolean, null: false , default: false
  end
end
