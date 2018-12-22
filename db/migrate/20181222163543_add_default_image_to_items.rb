class AddDefaultImageToItems < ActiveRecord::Migration[5.1]
  def change
    change_column :items, :image, :string, :default => "/no_image_available.jpg"
  end
end
