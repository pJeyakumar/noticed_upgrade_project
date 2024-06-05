class User < ApplicationRecord
    has_many :logbook_entries, class_name: "LogbookEntry", foreign_key: "pilot_in_command_id"
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true
end
