class InfluencerList < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id
  has_many :list_memberships, dependent: :destroy
  has_many :users, through: :list_memberships

  validates :name, presence: true, uniqueness: { scope: :user_id }

  def add_user(user)
    users << user
  end

  def remove_user(user)
    users.delete(user)
  end
end
