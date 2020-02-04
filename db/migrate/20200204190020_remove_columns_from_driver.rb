class RemoveColumnsFromDriver < ActiveRecord::Migration[5.2]
  def change
    remove_column :drivers, :image_file_name, t.string
    remove_column :drivers, :image_content_type, t.string
    remove_column :drivers, :image_file_size, t.integer
    remove_column :driver, image_updated_at, t.datetime
  end
end
