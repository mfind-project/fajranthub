class ChangeGoogleUserIdColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :google_user_id, :string
  end
end
