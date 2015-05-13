require 'rubygems'
require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller, :active_model

require 'rspec/rails'
require 'ffaker'
require 'factory_girl_rails'

RSpec.configure do |config|
end