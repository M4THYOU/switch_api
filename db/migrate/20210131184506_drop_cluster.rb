class DropCluster < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :thing_clusters, :clusters
    drop_table :clusters
    drop_table :thing_clusters
  end
end
