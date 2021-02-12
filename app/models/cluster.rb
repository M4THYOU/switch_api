class Cluster < ApplicationRecord
    belongs_to :cluster_group, class_name: 'u_group', dependent: :destroy
    belongs_to :family_group, class_name: 'u_group', dependent: :destroy
end
