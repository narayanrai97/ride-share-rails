class AddCancellationCategoryRefToReasons < ActiveRecord::Migration[5.2]
  def change
    add_reference :reasons, :cancellation_category, foreign_key: true
  end
end
