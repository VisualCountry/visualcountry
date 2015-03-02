class Vine
  class InvalidToken < StandardError; end
  class InvalidUsernameOrPassword < StandardError; end
  class ConnectionIssue < StandardError; end

  class Video < OpenStruct; end
  class User < OpenStruct; end

  attr_reader :token

  VINE_BASE_URL = 'https://vine.co/api'

  def initialize(vine_token, email = nil, password = nil)
    @token = vine_token || fetch_token(email, password)
    @user_id = fetch_user_id(token)
  end

  def self.from_auth(email, password)
    new(nil, email, password)
  end

  def media
    @media ||= begin
      vine_media = get("#{VINE_BASE_URL}/timelines/users/#{user_id}")
      vine_media.fetch('records').map { |hash| Video.new(hash) }
    end
  end

  def user
    @user ||= User.new(user_data)
  end

  private

  attr_reader :user_id, :user_data

  def fetch_token(email, password)
    @fetch_token ||= begin
      payload = {username: email, password: password}
      post("#{VINE_BASE_URL}/users/authenticate", payload).fetch('key')
    end
  end

  def fetch_user_id(token)
    user_data.fetch('userId')
  end

  def user_data
    @user_data ||= get("#{VINE_BASE_URL}/users/me")
  end

  def get(url, headers = {})
    handle_exception do
      headers.merge!({'vine-session-id' => token})
      response = RestClient.get(url, headers)
      JSON.parse(response).fetch('data')
    end
  end

  def post(url, payload = {}, headers = {})
    handle_exception do
      response = RestClient.post(url, payload, headers)
      JSON.parse(response).fetch('data')
    end
  end

  def handle_exception(&block)
    yield
  rescue RestClient::Unauthorized => exception
    raise InvalidToken
  rescue RestClient::BadRequest => exception
    raise InvalidUsernameOrPassword
  rescue SocketError => exception
    raise ConnectionIssue
  end
end
