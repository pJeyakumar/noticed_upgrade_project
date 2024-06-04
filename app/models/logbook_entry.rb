class LogbookEntry < ApplicationRecord
    belongs_to :aircraft
    belongs_to :pilot_in_command, class_name: "User", optional: false
    belongs_to :second_in_command, class_name: "User", optional: true
  
    enum time_of_day: {
      day: 0,
      night: 1
    }
end
