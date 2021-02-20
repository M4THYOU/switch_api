class Thing < ApplicationRecord
  has_many :u_roles
  has_secure_password
end
