# == Schema Information
#
# Table name: campaigns
#
#  id                 :integer          not null, primary key
#  job_id             :integer
#  status             :integer
#  external_reference :integer
#  ad_description     :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryGirl.define do
  factory :campaign do
    job_id 12
    status :active
    external_reference 1
    ad_description "Description for campaign"
  end
end
