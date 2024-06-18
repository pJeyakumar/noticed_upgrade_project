FactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Doe" }
    email { "single@fj.com" }
    password { "password" }
  end
end
