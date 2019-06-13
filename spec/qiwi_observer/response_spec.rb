require 'spec_helper'

RSpec.describe QiwiObserver::Response do
  describe '#success?' do
    it 'returns true if response success' do
      stub_request(:get, "https://edge.qiwi.com/payment-history/v2/persons/77774889669/payments?operation=IN&rows=10").
        with(
          headers: {
         'Accept'=>'application/json',
         'Authorization'=>'Bearer 3ef97bca7bf63c78a94898326485a6c8',
         'Content-Type'=>'application/json'
          }).
        to_return(status: 200, body: File.new('spec/qiwi_observer/fixtures/payments.json'))
      request = QiwiObserver::Payments.new(wallet:'77774889669' , token: '3ef97bca7bf63c78a94898326485a6c8')
      response = request.call({rows: 10, operation: 'IN'})
      expect(response.success?).to eq true
    end
  end
end
