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

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should validate_presence_of(:job_id) }
  it { should validate_presence_of(:status) }

  it { should define_enum_for(:status).with([:active, :paused, :deleted]) }
end
