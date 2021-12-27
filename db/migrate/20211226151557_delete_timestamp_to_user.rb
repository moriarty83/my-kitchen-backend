class DeleteTimestampToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :delete_timestamp, :timestamp
  end
end
