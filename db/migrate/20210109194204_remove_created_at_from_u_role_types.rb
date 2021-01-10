class RemoveCreatedAtFromURoleTypes < ActiveRecord::Migration[6.1]
  def change
    remove_column :u_role_types, :created_at
    remove_column :u_role_types, :updated_at
  end
end
