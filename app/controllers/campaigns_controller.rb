require 'net/http'

class CampaignsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def verify
    payload = {
      campaigns: []
    }

    statuses = {
      'active' => 'enabled',
      'paused' =>'disabled',
      'deleted' => 'disabled'
    }

    ad_service_url = ENV['AD_SERVICE_URL']
    res = Net::HTTP.get(URI.parse(ad_service_url))
    ads = JSON.parse(res)['ads']

    params['campaigns'].each do |c|
      campaign = Campaign.find(c['id'])

      ad = ads.detect {|elem| elem['reference'] == campaign.external_reference.to_s }

      if not ad then
        payload[:campaigns] << { id: campaign.id, missing: true }
        next
      end

      campaign_payload = {
        id: campaign.id,
        status: {
          local_value: campaign.status,
          ad_service_value: ad['status'],
          consistent: statuses[campaign.status] == ad['status']
        },
        ad_description: {
          local_value: campaign.ad_description,
          ad_service_value: ad['description'],
          consistent: campaign.ad_description == ad['description']
        }
      }
      payload[:campaigns] << campaign_payload
    end

    render json: payload
  end
end
