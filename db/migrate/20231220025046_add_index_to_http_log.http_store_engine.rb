# This migration comes from http_store_engine (originally 4)
class AddIndexToHttpLog < ActiveRecord::Migration[5.2]
  def change
    add_index :http_logs, :client_type
  end
end
