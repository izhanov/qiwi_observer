require 'spec_helper'

RSpec.describe QiwiObserver::Response do
  describe '#short_info' do
    it 'returns array of hashes with :sender_id, :amount, :date & :comment keys' do
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
      expect(response.short_info.first).to include(:account_id, :amount, :date, :comment)
    end
  end
end
