class Thing < ApplicationRecord
  belongs_to :cluster
  has_secure_password
end
