module Ahoy
  class Message < ApplicationRecord
    self.table_name = "ahoy_messages"

    belongs_to :user, polymorphic: true, optional: true
  end
end
