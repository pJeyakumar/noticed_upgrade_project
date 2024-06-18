class AddContextToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :context, :string
  end
end
