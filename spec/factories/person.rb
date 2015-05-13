FactoryGirl.define do
  factory :person, class: 'Person' do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    initialize_with { new({name: name, email: email}) }
  end
end