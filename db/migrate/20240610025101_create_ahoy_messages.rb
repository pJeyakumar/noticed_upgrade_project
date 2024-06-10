# rubocop:disable Rails/CreateTableWithTimestamps
class CreateAhoyMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :ahoy_messages do |t|
      t.references :user, polymorphic: true
      t.string :to, index: true
      t.string :mailer
      t.text :subject
      t.datetime :sent_at
    end
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
