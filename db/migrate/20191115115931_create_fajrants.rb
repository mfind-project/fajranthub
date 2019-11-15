class CreateFajrants < ActiveRecord::Migration[5.2]
  def change
    create_table :fajrants do |t|
      t.references :user, foreign_key: true
      t.datetime :started_at
      t.datetime :ends_at
      t.text :description

      t.timestamps
    end
  end
end
