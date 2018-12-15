class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.integer :instock_qty
      t.decimal :price
      t.string :image
      t.text :description
      t.timestamps
    end
  end
end
