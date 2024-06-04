class CreateAircrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :aircrafts do |t|
      t.string :make
      t.string :model
      t.integer :engine

      t.timestamps
    end
  end
end