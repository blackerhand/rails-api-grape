class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  include Disable
  include PreEnum

  def self.ransackable_attributes(_auth_object = nil)
    %w[id]
  end
end
