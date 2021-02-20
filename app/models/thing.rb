class Thing < ApplicationRecord
  belongs_to :cluster
  has_many :u_roles
  has_secure_password
end
