class AddNewLibraryNameAndNewLibraryAddressToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :new_library_name, :string
    add_column :books, :new_library_address, :string
  end
end
