require 'spec_helper'

RSpec.describe PeopleController, :type => :controller do

	describe "GET index" do
    before do
      Person.stub(:all).and_return([
        Person.new(:name=>'john'  , :email=>'lennon@beatles.com'),
        Person.new(:name=>'george', :email=>'harrison@beatles.com')
      ])
    end

    it "should respond success" do
      get :index, :format => :pdf

      response.should be_success
    end

    it "should not contain nulls" do
      get :index, :format => :pdf

      response.should_not contain("null")
    end

    it "should show all fields in the report" do
      get :index, :format => :pdf

      response.should contain("john")
      response.should contain("lennon@beatles.com")
      response.should contain("george")
      response.should contain("harrison@beatles.com")
    end

    it "should clip the text if it's larger than the Text Field" do
      Person.stub(:all).and_return([
        Person.new(:name=>'jonh'  , :email=>'a_very_long_text_that_is_larger_than_the_text_field_in_the_report')
      ])

      get :index, :format => :pdf

      response.should_not contain("a_very_long_text_that_is_larger_than_the_text_field_in_the_report")
      response.should contain("a_very_long_text_that_is_larger_than_the_text_field_in_the_")
    end

    it "should show the parameters defined in the controller" do
      get :index, :format => :pdf

      response.should contain("I'm a parameter. I was defined in the controller")
    end

	end

  describe "GET compile_time_error_report" do

    it "should raise a RuntimeError if the report's design is not valid" do
      expect { get :compile_time_error_report, :format => :pdf }.to raise_error(RuntimeError, /Report design not valid/)
    end

  end

  describe "GET runtime_error_report" do

    it "should raise a RuntimeError if the report could not be filled due to a runtime error" do
      expect { get :runtime_error_report, :format => :pdf }.to raise_error(RuntimeError)
    end

  end

  describe "GET nil_datasource" do

    it "should treat nil datasources" do
      get :nil_datasource, :format => :pdf

      response.should contain("I'm a parameter. I was defined in the controller")
    end

  end

  describe "GET java_parameter" do

    it "accepts java parameter without converting it to string" do
      get :java_parameter, :format => :pdf

      response.should contain("The Beatles")
    end

  end
  
  describe "specifited template" do
    before do
      Person.stub(:all).and_return([
        Person.new(:name=>'john'  , :email=>'lennon@beatles.com'),
        Person.new(:name=>'george', :email=>'harrison@beatles.com')
      ])
    end

    it "should respond success with specifited template" do
      get :specifited_template, :format => :pdf

      response.should be_success
    end

  end

end
