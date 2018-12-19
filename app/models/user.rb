class User < ApplicationRecord
 validates_presence_of :email, :name, :role, :address, :city, :state, :zip_code
 validates_presence_of :password, if: :password
 validates_uniqueness_of :email
 validates_confirmation_of :password

 has_many :orders
 has_many :items
 enum role: ["registered", "merchant", "admin"]

 has_secure_password

 def status
   enabled? ? "Enabled" : "Disabled"
 end
end
