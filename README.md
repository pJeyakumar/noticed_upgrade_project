# README
### Purpose: 
The purpose of this project is to determine what changes will be need to made on our flight simulator tracking app when updating our Noticed gem from 1.6.0 to 2.3.2!

### Setup:
1. In your terminal clone this repository onto your local setup by running `git clone https://github.com/pJeyakumar/noticed_upgrade_project.git`
2. Run code . (this will run VSCode and open up repository)
3. Make sure you have the `Dev Containers` extension installed!
4. Press Cmd + Shift + P => Type "Dev Containers: Rebuild Container" and select the first option.
5. Run `bundle install`
6. Run `rails db:create db:migrate`
7. Run `bin/rails s -b 0.0.0.0` and go to the URL specified in your terminal







---- TEMP INSTRUCTIONS:


# notifications
gem "noticed", "~> 1.6.0"



rails generate noticed:model
rails db:migrate


class User < ApplicationRecord
  has_many :notifications, as: :recipient, dependent: :destroy



            "Message = Aircraft"

rails generate noticed:notification NewAircraftCreatedNotification






class NewAircraftCreatedNotification < ApplicationNotification

 deliver_by :database, debug: true


  deliver_by :database, if: :database_notifications?
  deliver_by :email, mailer: "AircraftMailer", method: "created_email", if: :email_notifications?

  # Variables that tells the system if it should send a notification if the recipient isn't subscribed
  DEFAULT_SEND_NOTIFICATION = true
  DEFAULT_SEND_EMAIL_NOTIFICATION = true

  # Add required params
  param :aircraft

  def message
    "#{params[:aircraft].name} has been created for use in the flight sim."
  end

  def url
    aircraft_path(params[:aircraft])
  end

  def database_notifications?
    DEFAULT_SEND_NOTIFICATION
  end

  def email_notifications?
    DEFAULT_SEND_EMAIL_NOTIFICATION
  end

  def self.targets
    # example of only sending notifications to admins. Really this just has to be an ActiveRecord::Relation of (likely) User objects.
    User.admin
  end
end


THEN in aircraft controller CREATE:


  after_create_commit :notify_user

  def notify_user
    MessageNotification.with(message: self).deliver_later(user)
  end


NewAircraftCreatedNotification.with(aircraft: aircraft).deliver_later(NewAircraftCreatedNotification.targets)


DO WE NEED A NOTIFICATION CONTROLLER? maybe not



