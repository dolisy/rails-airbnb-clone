class RemoveUserFromMessages < ActiveRecord::Migration[5.0]
  def change
    remove_reference :messages, :user, foreign_key: true
  end
end
