# == Schema Information
#
# Table name: resources
#
#  id              :bigint           not null, primary key
#  ancestry        :string(100)
#  description     :string(255)
#  disabled_at     :datetime
#  name            :string(100)      not null
#  status          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_user_id :bigint
#  updated_user_id :bigint
#
# Indexes
#
#  index_resources_on_ancestry  (ancestry)
#
class Resource < ApplicationRecord
end
