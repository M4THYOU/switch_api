class Thing < ApplicationRecord
  has_and_belongs_to_many :clusters
  has_secure_password
end
