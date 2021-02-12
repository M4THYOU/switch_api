class CreateClusters < ActiveRecord::Migration[6.1]
  def change
    create_table :clusters do |t|
      t.string :name
      t.references :cluster_group
      t.references :family_group

      t.timestamps
    end
  end
end
