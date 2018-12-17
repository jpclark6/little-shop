class ChangeBooleanColumns < ActiveRecord::Migration[5.1]
  def change
    change_column(:items, :enabled, :boolean, null: false, default: true)
    change_column(:users, :enabled, :boolean, null: false, default: true)

    change_column(:order_items, :fulfilled, :boolean, null: false)
  end
end
