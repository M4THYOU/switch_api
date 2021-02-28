class NameDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :users, :first_name, ''
    change_column_default :users, :last_name, ''
  end
end
