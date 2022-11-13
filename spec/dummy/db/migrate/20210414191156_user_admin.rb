class UserAdmin < ActiveRecord::Migration[6.0]
  def change
    create_table :users_admins do |t|
      t.boolean :is_admin
      t