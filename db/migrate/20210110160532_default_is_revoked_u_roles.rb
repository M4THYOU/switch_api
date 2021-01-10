class DefaultIsRevokedURoles < ActiveRecord::Migration[6.1]
  def change
    change_column_default :u_roles, :is_revoked, false
  end
end
