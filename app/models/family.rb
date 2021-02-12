class Family < ApplicationRecord
  belongs_to :family_group, class_name: 'UGroup', dependent: :destroy
end
