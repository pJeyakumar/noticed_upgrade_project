require "faker"

# Don't send emails during seed process.
ActionMailer::Base.perform_deliveries = false

# Clear existing data
ActiveRecord::Base.connection.execute("TRUNCATE logbook_entries, aircrafts, users, notifications RESTART IDENTITY CASCADE")

USERS_COUNT = 10
AIRCRAFT_NOTIFICATIONS_COUNT = 1000
LOGBOOK_ENTRY_NOTIFICATIONS = 1000
USER_NOTIFICATIONS = 100

# Create Users
users = USERS_COUNT.times.map do
  user = User.new(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    title: Faker::Job.title,
    company: Faker::Company.name
  )
  user.password = user.password_confirmation = Faker::Internet.password
  user.save!
  user
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
  aircraft = Aircraft.create!(aircraft_data)
  AIRCRAFT_NOTIFICATIONS_COUNT.times do
    notification = NewAircraftCreatedNotifier.with(aircraft: aircraft)
    notification.deliver_later(NewAircraftCreatedNotifier.targets)
  end
end

# Create Logbook Entries and Notifiers
LOGBOOK_ENTRY_NOTIFICATIONS.times do
  logbook_entry = LogbookEntry.create!(
    aircraft: Aircraft.order("RANDOM()").first,
    pilot_in_command: users.sample,
    second_in_command: [users.sample, nil].sample,
    date: Faker::Date.backward(days: 365),
    departure_icao: Faker::Address.country_code,
    arrival_icao: Faker::Address.country_code,
    duration: Faker::Number.between(from: 1, to: 10),
    time_of_day: LogbookEntry.time_of_days.keys.sample
  )
  new_logbook_notification = NewLogbookEntryCreatedNotifier.with(logbook_entry: logbook_entry)
  new_logbook_notification.deliver_later(NewLogbookEntryCreatedNotifier.targets)

  update_logbook_notification = LogbookEntryUpdatedNotifier.with(logbook_entry: logbook_entry)
  update_logbook_notification.deliver_later(LogbookEntryUpdatedNotifier.targets)
end

# Create 1000 UserSignUpNotifier and UserUpdateNotifier
users.each do |user|
  USER_NOTIFICATIONS.times do
    sign_up_notification = UserSignUpNotifier.with(event_user: user)
    sign_up_notification.deliver_later(UserSignUpNotifier.targets)

    update_notification = UserUpdateNotifier.with(event_user: user)
    update_notification.deliver_later(UserUpdateNotifier.targets)
  end
end

Rails.logger.debug { "Seeded #{User.count} users, #{Aircraft.count} aircrafts, #{LogbookEntry.count} logbook entries, and #{Noticed::Notification.count} notification." }
