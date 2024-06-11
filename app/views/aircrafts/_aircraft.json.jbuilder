json.extract!(aircraft, :id, :created_at, :updated_at, :make, :model)
json.url(aircraft_url(aircraft, format: :json))
