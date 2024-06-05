class LogbookEntry < ApplicationRecord
    belongs_to :aircraft
    belongs_to :pilot_in_command, class_name: "User", optional: false
    belongs_to :second_in_command, class_name: "User", optional: true
    validates :date, presence: true
    validates :departure_icao, presence: true
    validates :arrival_icao, presence: true
    validates :duration, presence: true
    validates :aircraft_id, presence: true
    validates :pilot_in_command_id, presence: true
    validates :time_of_day, presence: true
  
    enum time_of_day: {
      day: 0,
      night: 1
    }
end
