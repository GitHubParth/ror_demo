class AddProfileImageToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :profile_img, :string
  end
end
