require 'spec_helper'

RSpec.describe PeopleController, :type => :controller do

	describe 'GET index' do
    before :each do
      @people = FactoryGirl.build_list(:person, SecureRandom.random_number(100))
      allow(Person).to receive(:all).and_return(@people)
    end

    it 'should respond success' do
      get :index, format: :pdf
      expect(response).to be_success
    end

    it 'should not contain nulls' do
      get :index, format: :pdf
      expect(response).to_not contain('null')
    end

    it 'should show all fields in the report' do
      get :index, format: :pdf
      @people.each do |person|
        expect(response).to contain(person.name)
        expect(response).to contain(person.email)
      end
    end
  end

  describe 'GET compile_time_error_report' do
    it 'should raise a RuntimeError if the report\'s design is not valid' do
      expect { 
        get :compile_time_error_report, format: :pdf
      }.to raise_error(RuntimeError, /Report design not valid/)
    end
  end

  describe 'GET runtime_error_report' do
    it 'should raise a RuntimeError if the report could not be filled due to a runtime error' do
      expect { 
        get :runtime_error_report, format: :pdf 
      }.to raise_error(RuntimeError)
    end
  end

  describe 'GET nil_datasource' do
    it 'should treat nil datasources' do
      get :nil_datasource, format: :pdf
      expect(response).to contain('I\'m a parameter. I was defined in the controller')
    end
  end

  describe 'GET java_parameter' do
    it 'accepts java parameter without converting it to string' do
      get :java_parameter, format: :pdf
      expect(response).to contain('The Beatles')
    end
  end
  
  describe 'specifited template' do
    before do
      @people = FactoryGirl.build_list(:person, SecureRandom.random_number(100))
      allow(Person).to receive(:all).and_return(@people)
    end

    it "should respond success with specifited template" do
      get :specifited_template, format: :pdf
      expect(response).to be_success
    end
  end
end