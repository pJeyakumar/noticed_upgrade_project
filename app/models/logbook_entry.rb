class LogbookEntry < ApplicationRecord
  belongs_to :aircraft
  belongs_to :pilot_in_command, class_name: "User", optional: false, inverse_of: :logbook_entries
  belongs_to :second_in_command, class_name: "User", optional: true

  validates :date, presence: true
  validates :departure_icao, presence: true
  validates :arrival_icao, presence: true
  validates :duration, presence: true

  validates :time_of_day, presence: true

  after_create_commit :notify_creation_to_user
  after_update :notify_update_to_user

  enum time_of_day: {
    day: 0,
    night: 1
  }

  private

  def notify_creation_to_user
    NewLogbookEntryCreatedNotifier.with(logbook_entry: self).deliver_later(NewLogbookEntryCreatedNotifier.targets)
  end

  def notify_update_to_user
    LogbookEntryUpdatedNotifier.with(logbook_entry: self).deliver_later(LogbookEntryUpdatedNotifier.targets)
  end
end
