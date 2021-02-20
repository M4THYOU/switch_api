class AllowThingRoles < ActiveRecord::Migration[6.1]
  def change
    change_column_default :u_roles, :user_id, nil
    remove_column :u_roles, :thing_id
    add_reference :u_roles, :thing, foreign_key: { to_table: :things}
  end
end
