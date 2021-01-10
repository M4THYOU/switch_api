class RemoveTimeThingClusters < ActiveRecord::Migration[6.1]
  def change
    remove_column :thing_clusters, :updated_at
    remove_column :thing_clusters, :created_at
  end
end
