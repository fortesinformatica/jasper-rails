class PeopleController < ActionController::Base
  respond_to :xml, :pdf

  def index
    @people = Person.all
    respond_with @people
  end

end
