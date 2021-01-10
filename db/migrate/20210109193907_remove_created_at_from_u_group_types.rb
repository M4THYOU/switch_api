class RemoveCreatedAtFromUGroupTypes < ActiveRecord::Migration[6.1]
  def change
    remove_column :u_group_types, :created_at
    remove_column :u_group_types, :updated_at
  end
end
