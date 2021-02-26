class Thing < ApplicationRecord
  belongs_to :thing_type
  has_many :u_roles, :dependent => :destroy
  has_secure_password
end
