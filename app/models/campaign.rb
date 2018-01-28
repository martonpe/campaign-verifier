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

class Campaign < ApplicationRecord
  enum status: [ :active, :paused, :deleted ]

  validates_presence_of :job_id, :status
end
