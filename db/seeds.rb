# db/seeds.rb

require "faker"

# Create Users
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    title: Faker::Job.title,
    company: Faker::Company.name
  )
end

# Aircraft data with adjusted engine types
aircrafts = [
  { make: "CF-188 Hornet", model: "CF-18 Hornet", engine: "multi" },
  { make: "CC-130J Hercules", model: "CC-130J Hercules", engine: "multi" },
  { make: "CC-177 Globemaster III", model: "CC-177 Globemaster III", engine: "multi" },
  { make: "CH-147F Chinook", model: "CH-147F Chinook", engine: "multi" },
  { make: "CH-148 Cyclone", model: "CH-148 Cyclone", engine: "multi" },
  { make: "CH-146 Griffon", model: "CH-146 Griffon", engine: "single" },
  { make: "CC-150 Polaris", model: "CC-150 Polaris", engine: "multi" },
  { make: "CT-114 Tutor", model: "CT-114 Tutor", engine: "single" },
  { make: "CT-155 Hawk", model: "CT-155 Hawk", engine: "single" },
  { make: "CT-156 Harvard II", model: "CT-156 Harvard II", engine: "single" },
  { make: "CP-140 Aurora", model: "CP-140 Aurora", engine: "multi" },
  { make: "CC-144 Challenger", model: "CC-144 Challenger", engine: "multi" },
  { make: "CF-188 Hornet", model: "CF-18 Hornet", engine: "multi" },
  { make: "CC-130J Hercules", model: "CC-130J Hercules", engine: "multi" },
  { make: "CC-177 Globemaster III", model: "CC-177 Globemaster III", engine: "multi" },
  { make: "CH-147F Chinook", model: "CH-147F Chinook", engine: "multi" },
  { make: "CH-148 Cyclone", model: "CH-148 Cyclone", engine: "multi" },
  { make: "CH-146 Griffon", model: "CH-146 Griffon", engine: "single" },
  { make: "CC-150 Polaris", model: "CC-150 Polaris", engine: "multi" },
  { make: "CT-114 Tutor", model: "CT-114 Tutor", engine: "single" }
]

# Create Aircrafts
aircrafts.each do |aircraft_data|
  Aircraft.create!(aircraft_data)
end
