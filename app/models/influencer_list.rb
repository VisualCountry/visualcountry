class InfluencerList < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: :user_id

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
