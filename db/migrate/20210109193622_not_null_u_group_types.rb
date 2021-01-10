class NotNullUGroupTypes < ActiveRecord::Migration[6.1]
  def change
    change_column_null :u_group_types, :group_type, false
  end
end
