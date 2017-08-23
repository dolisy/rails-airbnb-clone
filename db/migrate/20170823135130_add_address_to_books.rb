class AddAddressToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :address, :string
  end
end
