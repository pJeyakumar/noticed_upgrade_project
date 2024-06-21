class MigrateNotificationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
end
class MigrateNotificationsJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 10
  LIMIT = 100

  # Define the Notification model to access the old table
  class Notification < ApplicationRecord
    self.inheritance_column = nil
  end
  

  def perform(*args)  
    total_processed = 0

    last_processed_at = get_last_processed_at

    # Process notifications in batches  
    Notification.order(created_at: :desc).where("created_at > ?", last_processed_at).limit(LIMIT).find_in_batches(batch_size: BATCH_SIZE) do |batch|
      batch.each do |notification|
        return if total_processed >= LIMIT
        migrate_notification(notification)
        total_processed += 1      
      end    
    end
  end

  private

  def get_last_processed_at
    last_event = Noticed::Event.order(created_at: :asc).first
    last_event ? last_event.created_at : Time.at(0)
  end

  def migrate_notification(notification)      
    # Ensure the record has not already been migrated, Not sure about this query working in "Notice::Event", but something like this.    
    return if Noticed::Event.where(created_at: notification.created_at, params: Noticed::Coder.load(notification.params).with_indifferent_access).exists?

    attributes = notification.attributes.slice("type", "created_at", "updated_at").with_indifferent_access
    attributes[:type] = attributes[:type].sub("Notification", "Notifier")
    attributes[:params] = Noticed::Coder.load(notification.params)
    attributes[:params] = {} if attributes[:params].try(:has_key?, "noticed_error") # Skip invalid records

    attributes[:notifications_attributes] = [{
      type: "#{attributes[:type]}::Notification",
      recipient_type: notification.recipient_type,
      recipient_id: notification.recipient_id,
      read_at: notification.read_at,
      seen_at: notification.read_at,
      created_at: notification.created_at,
      updated_at: notification.updated_at
    }]
    
    Noticed::Event.create!(attributes)
  end
end
