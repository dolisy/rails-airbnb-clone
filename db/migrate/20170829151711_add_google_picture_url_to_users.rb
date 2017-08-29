class AddGooglePictureUrlToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_picture_url, :string
  end
end
