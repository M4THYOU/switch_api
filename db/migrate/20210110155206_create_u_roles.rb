class CreateURoles < ActiveRecord::Migration[6.1]
  def change
    create_table :u_roles do |t|
      t.references :u_role_type, null: false, foreign_key: true
      t.references :u_group, null: false, foreign_key: true

      t.integer :uid, :null => false
      t.datetime :created_on, :null => false, default: -> { 'CURRENT_TIMESTAMP' }
      t.integer :created_by_uid, :null => false
      t.datetime :expires_on
      t.boolean :is_revoked, :default => 0
      t.datetime :revoked_on
      t.integer :revoked_by_uid

    end
  end
end
