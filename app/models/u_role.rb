class URole < ApplicationRecord
  belongs_to :u_role_type
  belongs_to :u_group
  belongs_to :user
end
