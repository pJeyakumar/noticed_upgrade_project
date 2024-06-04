class CreateLogbookEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :logbook_entries do |t|

      t.timestamps
    end
  end
end
