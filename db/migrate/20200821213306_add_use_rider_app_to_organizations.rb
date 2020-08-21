class AddUseRiderAppToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :use_rider_app, :boolean, default: true
  end
end
