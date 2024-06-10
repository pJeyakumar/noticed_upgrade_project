module Ahoy
  class Store < Ahoy::DatabaseStore
  end
end

Ahoy.api = true
Ahoy.track_bots = true
Ahoy.visit_duration = 4.hours
Ahoy.cookie_domain = :all
Ahoy.server_side_visits = :when_needed
