class RemoveNumberOfPagesFromBooks < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :number_of_pages, :integer
  end
end
