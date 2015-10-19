if defined? Raygun
  require 'raygun/sidekiq'

  Raygun.setup do |config|
    config.api_key = ENV['RAYGUN_APIKEY']
    config.filter_parameters = Rails.application.config.filter_parameters

    # The default is Rails.env.production?
    config.enable_reporting = (ENV.fetch('EXCEPTIONS_ENABLED') == 'true')
  end
end
