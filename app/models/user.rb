class User < ApplicationRecord
 validates_presence_of :email, :name, :role, :password, :address, :city, :state, :zip_code
 validates_uniqueness_of :email

 has_many :orders
 has_many :items
 enum role: ["registered", "merchant", "admin"]
end
