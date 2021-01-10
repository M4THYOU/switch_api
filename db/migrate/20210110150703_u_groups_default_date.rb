class UGroupsDefaultDate < ActiveRecord::Migration[6.1]
  def change
    change_column_default :u_groups, :created_on, -> { 'CURRENT_TIMESTAMP' }
  end
end
