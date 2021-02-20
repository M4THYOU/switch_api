class ReferenceCorrectTable < ActiveRecord::Migration[6.1]
  def change
    remove_column :things, :thing_type_id
    add_reference :things, :thing_type, foreign_key: { to_table: :thing_types}, null: false
  end
end
