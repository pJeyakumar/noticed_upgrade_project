require "faker"

FactoryBot.define do
  factory :logbook_entry do
    date { Faker::Date.forward(days: 1) }
    departure_icao { "Doe" }
    arrival_icao { "single@fj.com" }
    duration { 1 }

    association :aircraft
    association :pilot_in_command, factory: :user

    time_of_day { 0 }
  end
end
