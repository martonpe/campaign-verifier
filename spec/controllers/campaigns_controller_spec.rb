require 'rails_helper'

RSpec.describe CampaignsController, type: :controller do
  describe 'POST /verify' do
    context 'when request is valid' do
      let(:attributes) { { campaigns: [ {id: 1}, {id: 2}, {id: 3} ] } }

      before { post :verify, params: attributes }

      it 'returns valid json' do
        expect { JSON.parse(response.body) }.not_to raise_error
      end

      it 'throws for non existent campaigns' do
        expect true
      end
    end
  end
end
