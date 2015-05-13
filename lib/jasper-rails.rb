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
require "rjb-loader"
require "active_support/core_ext"
require "active_model"

if Rails.version >= "4.2"
  require "action_controller/metal/renderers"
else
  require "action_controller/metal/responder"
end

require "jasper-rails/abstract_renderer"
require "jasper-rails/jasper_reports_renderer"
require "jasper-rails/default_renderer"

module JasperRails

  class << self
    attr_accessor :config
  end
  
  self.config = {
    :report_params    => {},
    :response_options => {},
    :xml_options      => {}
  }
  
  RjbLoader.before_load do |config|
    # This code changes the JVM classpath, so it has to run BEFORE loading Rjb.
    Dir["#{File.dirname(__FILE__)}/java/*.jar"].each do |path|
      config.classpath << File::PATH_SEPARATOR + File.expand_path(path)
    end
  end
  
  RjbLoader.after_load do |config|
    # This code needs java classes, so it has to run AFTER loading Rjb.
    _Locale = Rjb::import 'java.util.Locale'
    JasperRails.config[:report_params]["XML_LOCALE"]       = _Locale.new('en', 'US')
    JasperRails.config[:report_params]["REPORT_LOCALE"]    = _Locale.new('en', 'US')
    JasperRails.config[:report_params]["XML_DATE_PATTERN"] = 'yyyy-MM-dd'
    JasperRails.config[:response_options][:disposition]    = 'inline'    
    JasperRails.config[:xml_options][:dasherize]           = false
  end
end