class Family < ApplicationRecord
  belongs_to :family_group, class_name: 'u_group', dependent: :destroy
end
