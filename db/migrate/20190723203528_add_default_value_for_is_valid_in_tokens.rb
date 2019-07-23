class AddDefaultValueForIsValidInTokens < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tokens, :is_valid, true
  end
end
