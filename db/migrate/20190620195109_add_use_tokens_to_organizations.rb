class AddUseTokensToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :use_tokens, :boolean, default: false
  end
end
