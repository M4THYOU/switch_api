class NoNullURoleUid < ActiveRecord::Migration[6.1]
  def change
    change_column_null :u_roles, :user_id, true
  end
end
