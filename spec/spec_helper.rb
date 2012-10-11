require 'rubygems'
require 'bundler'

Bundler.require :default, :development

Combustion.initialize! :action_controller

require 'rspec/rails'

RSpec.configure do |config|
end