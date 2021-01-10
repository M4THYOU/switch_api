class CreateUGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :u_groups do |t|
      t.references :u_group_type, null: false, foreign_key: true
      t.text :desc
      t.datetime :created_on
      t.integer :created_by_uid

      t.timestamps
    end
  end
end
