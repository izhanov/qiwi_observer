require 'spec_helper'

RSpec.describe QiwiObserver::Response do
  describe '#short_info' do
    it 'returns array of hashes with :sender_id, :amount, :date & :comment keys' do
      request = QiwiObserver::Payments.new(wallet:'77774889669' , token: '3ef97bca7bf63c78a94898326485a6c8')
      response = request.call({rows: 10, operation: 'IN'})
      puts response.short_info
      expect(response.short_info.first).to include(:sender_id, :amount, :date, :comment)
    end
  end
end
