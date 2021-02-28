class NullablePassword < ActiveRecord::Migration[6.1]
  def change
    # Don't do this, there are better strategies.
    # change_column_null :users, :encrypted_password, true
  end
end
