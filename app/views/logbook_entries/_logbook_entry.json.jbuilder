json.extract! logbook_entry, :id, :created_at, :updated_at
json.url logbook_entry_url(logbook_entry, format: :json)
