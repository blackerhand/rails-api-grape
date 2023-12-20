require_relative '../../db/disabled_field'

ActiveRecord::Migration[7.0].class_eval do
  include DisabledField
end
