class AddCancellationReasonToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :cancellation_reason, :string
  end
end
