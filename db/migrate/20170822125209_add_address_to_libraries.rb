class AddAddressToLibraries < ActiveRecord::Migration[5.0]
  def change
    add_column :libraries, :address, :string
  end
end
