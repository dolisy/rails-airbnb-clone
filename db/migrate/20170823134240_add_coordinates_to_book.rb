class AddCoordinatesToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :latitude, :float
    add_column :books, :longitude, :float
  end
end
