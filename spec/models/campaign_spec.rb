require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should validate_presence_of(:job_id) }
  it { should validate_presence_of(:status) }

  it { should define_enum_for(:status).with([:active, :paused, :deleted]) }
end
