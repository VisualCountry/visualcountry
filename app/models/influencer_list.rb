class InfluencerList < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :list_memberships, dependent: :destroy
  has_many :users, through: :list_memberships

  validates :name, presence: true, uniqueness: { scope: :user_id }

  before_create :assign_uuid

  def add_user(user)
    if users.exclude?(user)
      users << user
    end
  end

  def add_users(new_users)
    self.users |= new_users
  end

  def remove_user(user)
    users.delete(user)
  end

  def to_param
    uuid
  end

  private

  def assign_uuid
    self.uuid = SecureRandom.uuid
  end
end
