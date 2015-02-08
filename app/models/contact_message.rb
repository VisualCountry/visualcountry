class ContactMessage < ActiveRecord::Base
  validates :name, :email_address, :body, presence: true
end
