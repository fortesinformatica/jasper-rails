# jasper-rails

Experimental JasperReports/Rails integration using Rjb (Java Ruby Bridge)

For rspec integration, see: [jasper-rails-rspec](http://github.com/fortesinformatica/jasper-rails-rspec).

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

## RSpec integration
Check out: [jasper-rails-rspec](http://github.com/fortesinformatica/jasper-rails-rspec).

## DEMO
For a running example, just clone: [jasper-rails-demo](http://github.com/fortesinformatica/jasper-rails-demo).

## Is this gem still experimental?
YES. We have just migrated this code from a internal project at Grupo Fortes. We already use this gem in a couple of projects and we are very happy with it.
However, pay attention that all the features it supports right now were based in those project's especific needs. Therefore you might find a lot of 
JasperResports' features that are not yet supported. So, use it at your own risk! 
   
## TODO
* Configuration
* Better error treatment
* More RSpec matchers
* SPECS!!!
