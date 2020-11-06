class ChangeRadiusDefaultTo100Mi < ActiveRecord::Migration[5.2]
  def up
    change_column_default :drivers, :radius, 100
  end

  def down
    change_column_default :drivers, :radius, 50
  end
end
