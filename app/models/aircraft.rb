class Aircraft < ApplicationRecord
  has_many :logbook_entries

  enum engine: {
    single: 0,
    multi: 1
  }

  def to_s
    make + " " + model
  end
end
