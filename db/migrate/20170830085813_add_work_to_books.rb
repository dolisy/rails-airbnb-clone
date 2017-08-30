class AddWorkToBooks < ActiveRecord::Migration[5.0]
  def change
    add_reference :books, :work, foreign_key: true
  end
end
