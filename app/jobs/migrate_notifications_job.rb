class MigrateNotificationsJob < ApplicationJob
  require "benchmark"
  queue_as :default

  BATCH_SIZE = 5000
  LIMIT = 25000

  # Define the Notification model to access the old table
  class Notification < ApplicationRecord
    self.inheritance_column = nil
  end

  def perform(*args)  
    total_processed = 0
    total_noticed_events_created = 0
    total_noticed_events_errored = 0

    benchmark_result = Benchmark.measure do
      last_processed_at = get_last_processed_at

      # Process notifications in batches  
      Notification.order(created_at: :desc).where("created_at < ?", last_processed_at).limit(LIMIT).find_in_batches(order: :desc, batch_size: BATCH_SIZE) do |batch|
        batch.each do |notification|
          return if total_processed >= LIMIT
          
          begin
            migrate_notification(notification)
            total_processed += 1
          rescue => e
            total_noticed_events_errored += 1
            Rails.logger.error("Error processing notification ID #{notification.id}: #{e.message}")
          end
        end    
        total_noticed_events_created += batch.size
        Rails.logger.info("Completed processing batch. Total Noticed::Notifications created so far: #{total_noticed_events_created}")
      end
    end

    Rails.logger.info("Time taken to process notifications: #{benchmark_result.total} seconds")
    Rails.logger.info("#{total_noticed_events_created} Noticed::Notifications created, #{total_noticed_events_errored} Noticed::Notifications errored, #{Noticed::Notification.count/Notification.count * 100}% of Notifications covered.")
    puts "" # Included this so that the terminal will show the end of the Rails.logger.info (instead of the beginning and forcing you to scroll all the way down)
  end

  private

  def get_last_processed_at
    last_event = Noticed::Event.order(created_at: :desc).last
    last_event ? last_event.created_at : DateTime.now
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
