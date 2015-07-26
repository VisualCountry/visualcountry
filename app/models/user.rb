class User < ActiveRecord::Base
  attr_reader :focus_tokens

  SOCIAL_PLATFORMS = %w(vine twitter instagram facebook pinterest)
  FOLLOWER_COUNT_METHODS = SOCIAL_PLATFORMS.map { |p| "#{p}_follower_count"}
  FOLLOWER_COUNT_COLUMNS = FOLLOWER_COUNT_METHODS.map { |p| "cached_#{p}"}

  after_save :update_total_follower_count!

  belongs_to :profile

  validates :password, length: { in: 6..128 }, on: :update, allow_blank: true

  scope :by_created_at, -> { order(created_at: :desc) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable,
         omniauth_providers: [:facebook, :instagram, :twitter, :pinterest]

  delegate :media, to: :instagram, prefix: true, allow_nil: true
  delegate :media, to: :vine, prefix: true, allow_nil: true

  def update_total_follower_count!
    return unless (changed & FOLLOWER_COUNT_COLUMNS).present?

    changes_applied
    total_follower_count = follower_counts.inject(:+)
    update(total_follower_count: total_follower_count)
  end

  def warm_follower_count_cache
    !!follower_counts
  end

  def instagram_follower_count
    from_database_or_service(:instagram)
  end

  def vine_follower_count
    from_database_or_service(:vine)
  end

  def twitter_follower_count
    from_database_or_service(:twitter)
  end

  def facebook_follower_count
    from_database_or_service(:facebook)
  end

  def pinterest_follower_count
    #TODO
  end

  def has_account?
    true
  end

  # Devise, I hate you so much.
  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  private

  def instagram
    @instagram ||= InstagramAdapter.from_user(self)
  end

  def vine
    @vine ||= VineAdapter.from_user(self)
  end

  def twitter
    @twitter ||= TwitterAdapter.from_user(self)
  end

  def facebook
    @facebook ||= FacebookAdapter.from_user(self)
  end

  def from_database_or_service(platform)
    follower_count = "cached_#{platform}_follower_count"

    if attribute_present?(follower_count)
      attributes[follower_count]
    else
      return unless send(platform)

      send(platform).follower_count.tap do |count|
        update!(follower_count => count)
      end
    end
  end

  def follower_counts
    FOLLOWER_COUNT_METHODS.map { |p| send(p) }.compact
  end

  protected

  def confirmation_required?
    facebook_token? ? false : true
  end
end
