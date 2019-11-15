class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :google_user_id
      t.string :name
      t.integer :pn_user_id

      t.timestamps
    end
  end
end
