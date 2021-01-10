class CreateThingClusters < ActiveRecord::Migration[6.1]
  def change
    create_table :thing_clusters do |t|
      t.references :thing, null: false, foreign_key: true
      t.references :cluster, null: false, foreign_key: true

      t.timestamps
    end
  end
end
