class NullableUser < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :first_name, true
    change_column_null :users, :last_name, true
    change_column_null :users, :encrypted_password, true
    remove_column :users, :is_invited
  end
end
