class ChangeOrdersToDefaultPending < ActiveRecord::Migration[5.1]
  def change
    change_column(:orders, :status, :integer, null: false, default: 0)
  end
end
