class BaseService
  def initialize(user, service)
    @user = user
    @service = service
  end

  def self.from_user(user, service)
    return unless user.send("#{service}_token")

    new(user, service)
  end

  private

  attr_reader :user, :service

  def service_token
    user.send("#{service}_token")
  end

  def client
    raise NotImplementedError
  end
end