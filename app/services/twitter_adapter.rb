class TwitterAdapter < BaseAdapter
  def self.from_user(user)
    return unless user.twitter_token && user.twitter_token_secret

    super(user, :twitter)
  end

  def follower_count
    client.current_user.followers_count
  end

  private

  def client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('TWITTER_SECRET_KEY')
      config.access_token        = service_token
      config.access_token_secret = user.twitter_token_secret
    end
  end
end