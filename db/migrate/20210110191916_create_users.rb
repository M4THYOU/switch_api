class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, unique: true, :null => false
      t.string :password_digest, :null => false
      t.string :confirm_token
      t.boolean :is_invited, :null => false, :default => false
      t.boolean :is_active, :null => false, :default => false
      t.datetime :created_on, :null => false, default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :users, :confirm_token, unique: true
  end
end
