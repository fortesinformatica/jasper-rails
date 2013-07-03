#
# Copyright (C) 2012 Marlus Saraiva, Rodrigo Maia
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require "jasper-rails/version"
require "rails"
require "nokogiri"
require "rjb"
require "action_controller/metal/responder"

require "jasper-rails/abstract_renderer"
require "jasper-rails/jasper_rails_renderer"
require "jasper-rails/default_renderer"

module JasperRails

  class << self
    attr_accessor :before_initialize_blocks
    attr_accessor :after_initialize_blocks
    attr_accessor :config
  end
  
  self.before_initialize_blocks = []
  self.after_initialize_blocks  = []
  self.config = {
    :classpath        => '.',
    :report_params    => {},
    :response_options => {}
  }
  
  def self.before_initialize &block
    self.before_initialize_blocks << block 
  end
  
  def self.after_initialize &block
    self.after_initialize_blocks << block 
  end
  
  def self.add_classpath glob_pattern
    Dir[glob_pattern].each do |path|
      config[:classpath] << File::PATH_SEPARATOR + File.expand_path(path)
    end
  end
    
  def self.init    
    before_initialize_blocks.each do |block|
      block.call(config)
    end

    Rjb::load( config[:classpath], ['-Djava.awt.headless=true','-Xms128M', '-Xmx256M'] )
    
    after_initialize_blocks.each do |block|
      block.call(config)
    end
  end

  before_initialize do |config|
    add_classpath "#{File.dirname(__FILE__)}/java/*.jar"
    add_classpath "lib/*.jar"    
  end
  
  after_initialize do |config|
    _Locale = Rjb::import 'java.util.Locale'
    config[:report_params]["XML_LOCALE"]       = _Locale.new('en', 'US')
    config[:report_params]["REPORT_LOCALE"]    = _Locale.new('en', 'US')
    config[:report_params]["XML_DATE_PATTERN"] = 'yyyy-MM-dd'
    config[:response_options][:disposition]    = 'inline'    
  end
  
  class Railtie < Rails::Railtie
    config.after_initialize do
      JasperRails.init
    end
  end
  
end
