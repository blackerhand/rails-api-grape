# This migration comes from http_store_engine (originally 3)
class AddRetryTimesFieldToHttpLog < ActiveRecord::Migration[5.2]
  def change
    add_column :http_logs, :retry_times, :integer
  end
end
