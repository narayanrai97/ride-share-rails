class RenameCancellationReasonsToCancellationCategories < ActiveRecord::Migration[5.2]
  def change
    rename_table :cancellation_reasons, :cancellation_categories
  end
end
