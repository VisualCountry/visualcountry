ruby '2.1.2'

source 'https://rubygems.org'

gem 'dotenv-rails', :groups => [:development, :test]

gem 'high_voltage', '~> 2.2.1'

#gem 'turbolinks'
gem 'autoprefixer-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.3'
gem 'sdoc', '~> 0.4.0',          group: :doc
gem 'uglifier', '>= 1.3.0'

gem 'pg'
gem 'unicorn'

gem 'geocoder'

# CSS Frameworks
gem 'bootstrap-sass'
gem 'bourbon'

# HTTP Client
gem 'rest-client'

# Caching
gem 'dalli'

# Third Party Authentication
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-instagram'
gem 'omniauth-twitter'
gem 'omniauth-pinterest'

# Social Media Gems
gem 'koala'
gem 'instagram'
gem 'twitter'

# attaching images
gem "paperclip"

# Nested Forms and forms
gem 'cocoon'
gem 'simple_form'

# Debuggers
gem 'pry-rails'

group :production, :staging do
  gem 'rails_12factor'
  gem 'raygun4ruby'
  gem 'aws-sdk', '~> 1.20.0'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'webmock'
end

group :development do
  gem 'spring'
end
