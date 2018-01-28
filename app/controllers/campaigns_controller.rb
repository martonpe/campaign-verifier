class CampaignsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def verify
    payload = {
      campaigns: [
        {
          id: 1,
          status: {
            value: 0,
            consistent: true
          },
          ad_description: {
            value: "Description for campaign 11",
            consistent: false
          }
        }
      ]
    }.to_json

    render json: payload
  end
end
