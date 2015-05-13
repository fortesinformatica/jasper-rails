source "http://rubygems.org"

gemspec

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
        when 'default'
          '4.2.1'
        when '4.0'
          { github: 'rails/rails', branch: '4-0-stable' }
        when '4.1'
          { github: 'rails/rails', branch: '4-1-stable' }
        when '4.2'
          { github: 'rails/rails', branch: '4-2-stable' }
        else
          "~> #{rails_version}"
        end

gem 'rails', rails

group :development, :test do
  gem 'byebug'

  gem 'combustion', '~> 0.3.2'

  gem 'responders'
  
  gem 'jasper-rails-rspec'

  gem 'ffaker'

  gem 'rspec-rails'

  gem 'factory_girl_rails', require: false

  gem 'shoulda-matchers', require: false

  gem 'codeclimate-test-reporter', require: false

  gem 'rubocop'

  gem 'spring'

  gem 'generator_spec'
end