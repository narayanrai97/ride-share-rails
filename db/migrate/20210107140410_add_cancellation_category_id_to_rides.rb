class AddCancellationCategoryIdToRides < ActiveRecord::Migration[5.2]
  def change
    add_column :rides, :cancellation_category_id, :string
  end
end
