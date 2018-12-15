class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :address
      t.string :email
      t.integer :role, default: 0
      t.string :password
      t.boolean :enabled
      t.timestamps
    end
  end
end
