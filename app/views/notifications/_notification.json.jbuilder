json.extract! notification, :id, :created_at, :updated_at, :recipient_type, :recipient_id, :type, :params, :read_at
json.url notification_url(notification, format: :json)
