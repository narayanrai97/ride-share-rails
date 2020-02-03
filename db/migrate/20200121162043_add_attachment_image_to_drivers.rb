class AddAttachmentImageToDrivers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :drivers do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :drivers, :image
  end
end
