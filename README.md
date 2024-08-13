# README
### Purpose: 
The purpose of this project is to determine the necessary changes for updating our flight simulator logbook app's Noticed gem from `1.6.0` to `2.3.2`!

It aims to provide a clear understanding of possible obstacles and decisions required, ensuring we can effectively plan the rollout for this upgrade in larger projects.

### What is our Flight Simulator Logbook App?
Pilots would use our flight simulator logbook app after completing their flights (for training or task-related purpose) to log flight details, such as Departure/Arrival locations, Second in Command pilots, Time Flown, Aircraft, and Types of Landings. 

Our flight simulator logbook app tracks all created aircraft, registered users, and displays logbooks where you are the Pilot in Command. 

The app also includes notifications which alert you when new aircraft are added, new users sign up, or new logbook entries are created.

### Setup:
1. In your terminal clone this repository onto your local setup by running `git clone https://github.com/pJeyakumar/noticed_upgrade_project.git`
2. Run `code .` (this will run VSCode and open up repository)
3. Make sure you have the `Dev Containers` extension installed!
4. Press `Cmd + Shift + P` => Type `Dev Containers: Rebuild Container` and select the first option.
5. Run `bundle install`
6. Run `rails db:create db:migrate`
> Note: You will need to include a password for your database instance, simply add `password: postgres` under line 4 of `config/database.yml`

> Optional: To have some data to work with, run `rails db:seed`
8. Run `bin/rails s -b 0.0.0.0` and go to the URL specified in your terminal

### Game Plan Overview:
1. Upgrade Noticed gem to 2.3.2.
2. Create the new noticed tables (empty).
3. Make the necessary code changes so that the "new notifications" work.
     - any new notifications that users create will be created in the "new notifications" table
4. Run the job to populate the "new notifications" table using the "old notifications" table (i.e.
    - the job will convert the old notifications in descending order by date.
5. Remove the job.
6. Drop the old notifications table.


### Noticed 2.3.2 Upgrade Guide:
1. Create the following migration files via `rails g migration CreateNoticedTables` and `rails g migration AddNotificationsCountToNoticedEvent ` and copy the contents below into those corresponding files.
```ruby
class CreateNoticedTables < ActiveRecord::Migration[7.1]
  def change
    primary_key_type, foreign_key_type = primary_and_foreign_key_types
    create_table :noticed_events, id: primary_key_type do |t|
      t.string :type
      t.belongs_to :record, polymorphic: true, type: foreign_key_type
      if t.respond_to?(:jsonb)
        t.jsonb :params
      else
        t.json :params
      end

      t.timestamps
    end

    create_table :noticed_notifications, id: primary_key_type do |t|
      t.string :type
      t.belongs_to :event, null: false, type: foreign_key_type
      t.belongs_to :recipient, polymorphic: true, null: false, type: foreign_key_type
      t.datetime :read_at
      t.datetime :seen_at

      t.timestamps
    end
  end

  private

  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || :bigint
    [primary_key_type, foreign_key_type]
  end
end
```

```ruby
class AddNotificationsCountToNoticedEvent < ActiveRecord::Migration[7.1]
  def change
    add_column :noticed_events, :notifications_count, :integer
  end
end
```
2. Run `rails db:migrate` to add the above tables to the database.
3. Update the `noticed` gem in the `Gemfile` to `gem "noticed", "~> 2.3", ">= 2.3.2"` and run `bundle install`
4. Make the following changes to the codebase:
- Delete the `Notification` model in `app/models/notification.rb`.
  - Noticed v2 adds models managed by the gem.
- Rename the `app/notifications` folder to `app/notifiers`
- Rename all `notification` classes to be `notifier` by running the following code in `rails console`
```ruby
require 'fileutils'

dir = 'app/notifiers'

Dir.glob("#{dir}/*_notification.rb").each do |file|
new_file = file.gsub('notification', 'notifier')
  FileUtils.mv(file, new_file)
  puts "Renamed: #{file} to #{new_file}"
end
```
- Rename the `spec/notifications` folder to `spec/notifiers`
- Rename all `notification` classes to be `notifier` by running the following code in `rails console`
```ruby
require 'fileutils'

dir = 'spec/notifiers'

Dir.glob("#{dir}/*_notification_spec.rb").each do |file|
new_file = file.gsub('notification', 'notifier')
  FileUtils.mv(file, new_file)
  puts "Renamed: #{file} to #{new_file}"
end
```
- Rename all `Notification` classes to `Notifier`
  - In VS Code (or RubyMine) Search for `Notification <` and replace with `Notifier <`
  - You will also need to change all calls to Notification classes (e.g. LogbookEntryUpdatedNotification) to it's corresponding Notifier name (i.e. LogbookEntryUpdatedNotifier).
    > Note: you need to change ALL CALLS to the `Notification` class to `Noticed::Notification`
    > Note: the `type` value in the `Notification` table will become `LogbookEntryUpdatedNotification::Notification` (it was `LogbookEntryUpdatedNotification` before)
  - e.g. `LogbookEntryUpdatedNotification` becomes `LogbookEntryUpdatedNotifier`
-  ` <%= render notification %>` will have to change to `<%= render partial: "notification", locals: {notification: notification} %>`
- Wrap all helper methods in the `notifier` classes with a new block `notification_methods do … end`
  > Note: DO NOT wrap `def self.targets` in the block, it is  NOT a helper method
- Change your `has_many :notifications, as: :recipient, dependent: :destroy` relationship to `has_many :noticed_notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"`
- Change all instances of `has_many_notifications` to `has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"`
  > Note: if you have more than one `has_noticed_notifications` you should remove all but one (since there can only be 1 relationship to the model).
- Add the `has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"` to the `user.rb` model
- Change all instances of `deliver` to `deliver_later`.
  - Notifications are now always delivered later (meaning both of the above methods do the same thing), but we should change it to `deliver_later` for better clarity.
- Change all instances of `param` and `params` in the `notifier` classes to `required_param` and `required_params` respectively.
  - search for `param` with EXACT MATCHING enabled and for the FILES TO INCLUDE search for `*_notifier.rb` and change to `required_param`
    - search for `params ` (there is a SPACE in after "params") with EXACT MATCHING enabled and for the FILES TO INCLUDE search for `*_notifier.rb` and change to `required_params`
      > Note: we do NOT change the `params` in the helper methods
- Change all instances of `mark_as_read!` to `mark_as_read` and `mark_as_unread!` to `mark_as_unread`.
- Change all instances of `Noticed::Base`: to `Noticed::Event`.
- Remove all instances of `deliver_by :database` from notifiers.
  - The database delivery is now baked into notifications.
- Email Delivery Method
  - `method` is now a required option. Previously, it was inferred from the notification name but we've decided it would be better to be explicit.
  - e.g. the line `deliver_by :email, mailer: "TestMailer"` in `test_notification.rb` must be changed to `deliver_by :email, mailer: "TestMailer", method: "test"`where the method "test" is a function in `test_mailer.rb`.
 
5. To migrate the data into new tables:
  - Create a `job` to loop through all existing notifications and create a new record for each one.
  - We can implement an ActiveJob (in `app/jobs/migrate_notifications_job.rb`) like this one:
```ruby
class MigrateNotificationsJob < ApplicationJob
  queue_as :default

  # ADJUST BATCH_SIZE AND LIMIT AS NEEDED
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
    # Notifications are ordered by created_at date (newest first)
    # We then scope them to only included notifications OLDER than our last_processed_at notification
    # Then we run them in batches, in order of PRIMARY KEY descending (should be the same as created_at desc), find_in_batches MUST be ordered by PRIMARY KEY (we can choose either ascending or descending order).
    Notification.order(created_at: :desc).where("created_at < ?", last_processed_at).limit(LIMIT).find_in_batches(order: :desc, batch_size: BATCH_SIZE) do |batch|
      batch.each do |notification|
        return if total_processed >= LIMIT
        migrate_notification(notification)
        total_processed += 1      
      end    
    end
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
```
- After verifying that each "old notification" has a corresponding "new notification" and Noticed is working without error, **Drop** the "old notification" table

 
