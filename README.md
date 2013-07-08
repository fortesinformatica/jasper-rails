# jasper-rails

JasperReports/Rails integration using Rjb (Ruby Java Bridge)

# News!
- jasper-rails 2.0.0.beta1 released!

## Dependencies

You need a Java Virtual Machine installed and set up in order to use this gem.

## Install

```
gem install jasper-rails
```

## Configure

Add `jasper-rails` to your Gemfile:

```ruby
  gem "jasper-rails"
```

Note: If you're running your application on OS X, this is usually all you have to do. On Linux, you might have
to set the JAVA_HOME. On Windows, good luck!

For any issues related to the java/ruby integration, please check out: [http://rjb.rubyforge.org/](http://rjb.rubyforge.org/). You will find here plenty tips that might help you to solve your problem.

## Using jasper-rails

1) Tell your controller that it "responds to" :pdf and it "responds with" some list:

Note: This list will become your datasource inside the report.

```ruby
  respond_to :html, :xml, :pdf

  def index
    @people = Person.all
    respond_with @people
  end
```

2) Create your jasper report source file using iReport or any compatible jasper tool.

3) Set the "Query Text" and "The language for the dataset query" properties of your report.

Note: If you're using iReport, you can find those properties in the "Properties panel".
Don't forget to select the report root node in your "Report inspector".

Example: If you have a list of people, you should have something like:
* "Query Text" = /people/person
* "The language for the dataset query" = xpath

4) Design your report (add fields, groups, images, etc.)

5) Save the report source file in your views folder (just like any other html view file):

Example:

* app/views/people/index.jrxml

## Parameters

```ruby
  def index
    @people = Person.all

    # This variable will be available in your report!
    @user = "John Doe"

    respond_with @people
  end
```

All you have to do now is to create, in iReport, a parameter called "user" (yes, without the "@") and drop it in your report!

Limitation: By now, all parameters that aren't manually converted to Rjb java classes/instances are converted to java String. We intend to change this in the near future.

## Passing Java parameters directly

```ruby
  title = (Rjb::import 'java.lang.String').new("The Beatles")
  @parameter_that_is_a_java_class = (Rjb::import 'java.util.HashMap').new
  @parameter_that_is_a_java_class.put("title", title)
```

For more information check out issue: [#13](https://github.com/fortesinformatica/jasper-rails/pull/13)

## Global configuration

You can change any default report param by setting JasperRails.config[:report_params], e.g., in your "config/application.rb" you might have something like:

```ruby
  config.after_initialize do
    JasperRails.config[:report_params]["REPORT_LOCALE"] = JasperRails::Locale.new('pt', 'BR')
  end
```

## RSpec integration
Check out: [jasper-rails-rspec](http://github.com/fortesinformatica/jasper-rails-rspec).

## DEMO
For a running example, just clone: [jasper-rails-demo](http://github.com/fortesinformatica/jasper-rails-demo).

## Mailing List
For any discussion related to this gem, feel free to join the [mailing list](https://groups.google.com/forum/#!forum/jasper-rails).

## History
This project was first developed at Grupo Fortes in 2011 and we have been using it in several projects since then.
Pay attention that all the features it supports right now were based in those project's especific needs. Therefore you might find a lot of
JasperResports' features that are not yet supported.

## LICENSE

Copyright (C) 2012 Marlus Saraiva, Rodrigo Maia

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
