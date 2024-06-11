class CreateLogbookEntries < ActiveRecord::Migration[7.1]
  def change
    create_table(:logbook_entries) do |t|
      t.references(:aircraft, foreign_key: { to_table: :aircrafts })
      t.datetime(:date)
      t.string(:departure_icao)
      t.string(:arrival_icao)
      t.float(:duration)
      t.references(:pilot_in_command, foreign_key: { to_table: :users })
      t.references(:second_in_command, foreign_key: { to_table: :users })
      t.float(:flt_training)
      t.float(:ground_training)
      t.float(:simulator)
      t.float(:cross_country)
      t.integer(:time_of_day)
      t.float(:actual_instrument)
      t.float(:simulated_instrument)
      t.integer(:day_landing)
      t.integer(:night_landing)
      t.integer(:single_engine_land)
      t.integer(:multi_engine_land)
      t.text(:notes)

      t.timestamps
    end
  end
end
