class ClusterRefToGroup < ActiveRecord::Migration[6.1]
  def change
    add_reference :clusters, :u_group, null: false, foreign_key: true
  end
end
