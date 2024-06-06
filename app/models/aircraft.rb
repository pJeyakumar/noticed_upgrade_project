class Aircraft < ApplicationRecord
  has_many :logbook_entries
  validates :make, presence: true
  validates :model, presence: true

  after_create_commit :notify_user

  def notify_user
    NewAircraftCreatedNotification.with(aircraft: self).deliver_later(NewAircraftCreatedNotification.targets)
  end

  enum engine: {
    single: 0,
    multi: 1
  }

  def to_s
    make + model
  end
end
