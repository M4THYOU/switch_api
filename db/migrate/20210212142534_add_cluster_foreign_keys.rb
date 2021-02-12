class AddClusterForeignKeys < ActiveRecord::Migration[6.1]
  def change
    drop_table :clusters
    create_table :clusters do |t|
      t.string :name
      t.references :cluster_group, null: false, foreign_key: {to_table: :u_groups}
      t.references :family_group, null: false, foreign_key: {to_table: :u_groups}

      t.timestamps
    end
  end
end
