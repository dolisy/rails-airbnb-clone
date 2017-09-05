class AddDefaultValurToIsbnInBooks < ActiveRecord::Migration[5.0]
  def change
    change_column :books, :isbn, :string, :default => "no isbn"
  end
end
