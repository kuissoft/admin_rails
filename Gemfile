source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~>4.0.0'
gem 'opentok' # TokBox Ruby SDK for generating OpenTok sessions and tokens
gem 'thin' # the most secure, stable, fast and extensible Ruby web server
gem 'active_model_serializers'

gem 'devise'
gem 'rock_config'
gem 'rest-client'

# Cache
gem 'memcachier'
gem 'dalli'

gem 'rapns'

# Rack Cors
gem "rack-cors", require: "rack/cors"

group :development, :test do
  gem 'sqlite3' # use sqlite3 as the database in development
  gem 'quiet_assets' # hide assets serving messages in logs
end

group :production do
  gem 'pg' # use postgres as the database in production (supported by Heroku)
  gem 'rails_12factor' # enable rails_serve_static_assets (to support css)

  # Monitoring
  gem 'sentry-raven'
  gem 'newrelic_rpm'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'simple_form'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'pry', '~> 0.9.12'
  gem 'pry-nav', '~> 0.2.3'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
