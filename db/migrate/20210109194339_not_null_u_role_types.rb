class NotNullURoleTypes < ActiveRecord::Migration[6.1]
  def change
    change_column_null :u_role_types, :role_type, false
    change_column_null :u_role_types, :name, false
  end
end
