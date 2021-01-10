class RemoveNameFromURoleTypes < ActiveRecord::Migration[6.1]
  def change
    remove_column :u_role_types, :name, :string
  end
end
