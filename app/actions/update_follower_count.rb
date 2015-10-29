class UpdateFollowerCount
  def initialize(profile_id, platform)
    @profile = Profile.find(profile_id)
    @platform = platform
  end

  def perform
    return unless profile

    if platform_follower_count
      profile.update!(follower_count_attribute => platform_follower_count)
    end
  rescue Twitter::Error::Unauthorized
    remove_token
  rescue Koala::Facebook::AuthenticationError
    remove_token
  end

  private

  attr_reader :profile, :platform

  def remove_token
    profile.user.update(platform_token_attribute => nil)
  end

  def follower_count_attribute
    "#{platform}_follower_count"
  end

  def platform_token_attribute
    "#{platform}_token"
  end

  def platform_follower_count
    return unless platform_adapter
    platform_adapter.follower_count
  end

  def platform_adapter
    platform_adapter_class.from_user(profile.user)
  end

  def platform_adapter_class
    "#{platform.capitalize}Adapter".constantize
  end
end
