# == Schema Information
#
# Table name: posts
#
#  id                     :bigint           not null, primary key
#  click_number(点击次数) :integer          default(0), not null
#  desc(说明)             :text(65535)
#  disabled_at            :datetime
#  title(标题)            :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  created_user_id        :bigint
#  updated_user_id        :bigint
#
# Indexes
#
#  index_posts_on_click_number  (click_number)
#  index_posts_on_disabled_at   (disabled_at)
#  index_posts_on_title         (title)
#
FactoryBot.define do
  factory :post do
    
  end
end
