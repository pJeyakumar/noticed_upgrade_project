class User < ApplicationRecord
    has_many :logbook_entries, class_name: "LogbookEntry", foreign_key: "pilot_in_command_id"
end
