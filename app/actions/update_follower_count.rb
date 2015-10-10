class UpdateFollowerCount
  def initialize(user_id, platform)
    @user = User.find(user_id)
    @platform = platform
  end

  def perform
    return unless user

    if platform_follower_count
      user.update(follower_count_attribute => platform_follower_count)
    end
  rescue Twitter::Error::Unauthorized
    remove_token
  rescue Koala::Facebook::AuthenticationError
    remove_token
  end

  private

  attr_reader :user, :platform

  def remove_token
    user.update(platform_token_attribute => nil)
  end

  def follower_count_attribute
    "cached_#{platform}_follower_count"
  end

  def platform_token_attribute
    "#{platform}_token"
  end

  def platform_follower_count
    return unless platform_adapter
    platform_adapter.follower_count
  end

  def platform_adapter
    user.send(platform)
  end
end
