class Person
  extend  ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  attr_accessor :name, :email

  def initialize(hash)
    hash.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def attributes
    instance_values
  end
end