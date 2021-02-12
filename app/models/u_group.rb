class UGroup < ApplicationRecord
  belongs_to :u_group_type
  has_many :u_roles
end
