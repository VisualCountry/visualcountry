class ContactMessage < ActiveRecord::Base
  validates :name, :email_address, :body, presence: true

  has_paper_trail
end
