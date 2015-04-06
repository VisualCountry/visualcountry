ruby '2.1.2'

source 'https://rubygems.org'

gem 'dotenv-rails', :groups => [:development, :test]

gem 'high_voltage', '~> 2.2.1'

gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
#gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0',          group: :doc

gem 'pg'
gem 'unicorn'

gem 'geocoder'

# CSS Frameworks
gem 'bootstrap-sass'

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
end

group :development do
  gem 'spring'
end
