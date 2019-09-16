class AddDefaultValueToApplicationState < ActiveRecord::Migration[5.2]
  def change
    change_column_default :drivers, :application_state, "pending"
  end
end
