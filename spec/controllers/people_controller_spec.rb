require 'spec_helper'

describe PeopleController do
	describe "GET listagem" do
    before do
      Person.stub(:all).and_return([Person.new(:name=>'jonh', :email=>'lennon@beatles.com'), Person.new(:name=>'paul', :email=>'paul@beatles.com')])
    end
    
    it "be success" do
      response.should be_success
    end
    
    it "should not contain nulls" do
      get :index, :format => :pdf
      response.should_not contain("null")
    end

    it "should contain emails" do
      get :index, :format => :pdf
      response.should contain("lennon@beatles.com")
      response.should contain("paul@beatles.com")
    end
	end
end