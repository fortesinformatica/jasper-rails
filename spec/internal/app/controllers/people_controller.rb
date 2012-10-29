class PeopleController < ActionController::Base
  respond_to :xml, :pdf

  def index
    @people = Person.all
    
    @parameter_defined_in_the_controller = "I'm a parameter. I was defined in the controller"
    
    respond_with @people
  end

  def compile_time_error_report    
    respond_with []
  end
  
  def runtime_error_report    
    respond_with []
  end

  def nil_datasource
    @parameter_defined_in_the_controller = "I'm a parameter. I was defined in the controller"
    respond_with nil
  end

end
