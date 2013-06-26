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
require "rjb"
require "action_controller/metal/responder"

require "jasper-rails/abstract_renderer"
require "jasper-rails/jasper_rails_renderer"
require "jasper-rails/default_renderer"

module JasperRails

  class << self
    attr_accessor :config
  end

  classpath = '.'
  Dir["#{File.dirname(__FILE__)}/java/*.jar"].each do |jar|
    classpath << File::PATH_SEPARATOR + File.expand_path(jar)
  end

  Dir["lib/*.jar"].each do |jar|
    classpath << File::PATH_SEPARATOR + File.expand_path(jar)
  end

  Rjb::load( classpath, ['-Djava.awt.headless=true','-Xms128M', '-Xmx256M'] )

  _Locale = Rjb::import 'java.util.Locale'
  
  # Default report params
  self.config = {
    :report_params=>{
      "REPORT_LOCALE"    => _Locale.new('en', 'US'),
      "XML_LOCALE"       => _Locale.new('en', 'US'),
      "XML_DATE_PATTERN" => 'yyyy-MM-dd'
    },
    :response_options=>{
      :disposition    => 'inline'
    }
  }

end
