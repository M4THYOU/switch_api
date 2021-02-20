class NotNullThingType < ActiveRecord::Migration[6.1]
  def change
    change_column_null :thing_types, :thing_type, false
    remove_column :things, :thing_type_id
    add_reference :things, :thing_type, foreign_key: { to_table: :things}, null: false
  end
end
