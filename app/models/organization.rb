class Organization < ActiveRecord::Base
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, presence: true, uniqueness: true
end
