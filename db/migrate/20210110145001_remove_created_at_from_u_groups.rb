class RemoveCreatedAtFromUGroups < ActiveRecord::Migration[6.1]
  def change
    remove_column :u_groups, :created_at
    remove_column :u_groups, :updated_at
  end
end
