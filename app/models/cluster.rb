class Cluster < ApplicationRecord
    belongs_to :cluster_group, class_name: 'UGroup', dependent: :destroy
    belongs_to :family_group, class_name: 'UGroup', dependent: :destroy
end
