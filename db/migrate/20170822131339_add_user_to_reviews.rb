class AddUserToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :user, :references
  end
end