require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  describe 'POST /verify' do

    before :each do
      ENV.stub(:[]).with("AD_SERVICE_URL").and_return("http://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df")
    end

    context 'when request is valid' do
      let!(:campaign_1) { FactoryGirl.create(:campaign,
                                             external_reference: 1,
                                             status: :active,
                                             ad_description: "Description for campaign 11") }
      let!(:campaign_2) { FactoryGirl.create(:campaign,
                                             external_reference: 2,
                                             status: :deleted,
                                             ad_description: "Description for campaign 1345") }
      let!(:campaign_3) { FactoryGirl.create(:campaign,
                                             external_reference: 3,
                                             status: :paused,
                                             ad_description: "Description for campaign 13") }
      let!(:campaign_4) { FactoryGirl.create(:campaign,
                                             external_reference: 4,
                                             status: :paused,
                                             ad_description: "Description for campaign 15") }

      let(:attributes) { { campaigns: [ {id: 1}, {id: 2}, {id: 3}, {id: 4} ] } }

      before { post :verify, params: attributes }

      it 'returns valid json' do
        expect {json}.not_to raise_error
      end

      it 'returns the requested number of campaigns' do
        expect(json['campaigns'].size).to eq(4)
      end

      it 'detects if status is inconsistent' do
        status = json['campaigns'][2]['status']

        expect(status['local_value']).to eq('paused')
        expect(status['ad_service_value']).to eq('enabled')
        expect(status['consistent']).to eq(false)
      end

      it 'detects if description is inconsistent' do
        description = json['campaigns'][1]['ad_description']

        expect(description['local_value']).to eq('Description for campaign 1345')
        expect(description['ad_service_value']).to eq('Description for campaign 12')
        expect(description['consistent']).to eq(false)
      end

      it 'detects if ad is missing' do
        expect(json['campaigns'][3]['missing']).to eq(true)
      end

      it 'returns consistent flags if ads and campaings match up' do
        campaign = json['campaigns'][0]

        expect(campaign['status']['consistent']).to eq(true)
        expect(campaign['ad_description']['consistent']).to eq(true)
        expect(campaign).to_not have_key('missing')
      end
    end

    context 'when request is invalid' do
      it 'throws for non existent campaigns' do
        expect { post :verify, params: { campaigns: [ {id: 23} ] } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end
end
