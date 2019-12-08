source 'https://rubygems.org'

gem 'hanami', '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'rake'

gem 'rom-repository'
gem 'rom-sql'

gem 'mysql2'

gem 'tilt-jbuilder', github: 'vladfaust/hanami-jbuilder'

gem 'rubocop-performance'

gem 'ibm_watson'
gem 'line-bot-api'

gem 'whenever', require: false

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'capybara'
  gem 'rspec'
end

group :production do
  # gem 'puma'
end

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'

  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', require: false
end
