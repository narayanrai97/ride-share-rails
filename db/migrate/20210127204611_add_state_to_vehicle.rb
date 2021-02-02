class AddStateToVehicle < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :car_state, :string
  end
end
