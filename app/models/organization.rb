class Organization < ActiveRecord::Base
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, presence: true, uniqueness: true

  def add_user(user)
    if users.exclude?(user)
      users << user
    end
  end
end
