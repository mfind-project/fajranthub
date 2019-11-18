class AddUniquenessToUserFields < ActiveRecord::Migration[5.2]
  def change
    add_index :users, [:email, :name, :google_user_id], unique: true
  end
end
