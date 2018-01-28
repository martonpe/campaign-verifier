class Campaign < ApplicationRecord
  enum status: [ :active, :paused, :deleted ]

  validates_presence_of :job_id, :status
end
