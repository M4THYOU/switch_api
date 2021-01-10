class NotNullUGroups < ActiveRecord::Migration[6.1]
  def change
    change_column_null :u_groups, :created_on, false
    change_column_null :u_groups, :created_by_uid, false

    change_column_default :u_groups, :created_on, DateTime.now
  end
end
