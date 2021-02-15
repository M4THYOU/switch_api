class AddisActivetoThing < ActiveRecord::Migration[6.1]
  def change
    add_column :things, :is_active, :integer, default: 0
  end
end
