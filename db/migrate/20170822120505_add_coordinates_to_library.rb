class AddCoordinatesToLibrary < ActiveRecord::Migration[5.0]
  def change
    add_column :libraries, :latitude, :float
    add_column :libraries, :longitude, :float
  end
end
