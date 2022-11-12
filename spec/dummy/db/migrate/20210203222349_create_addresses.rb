
class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses, { :id => false } do |t|
      t.string :city
      t.bigint :user_id
      t.timestamps
    end
  end
end