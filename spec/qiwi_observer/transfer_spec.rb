require 'spec_helper'
require './lib/qiwi_observer/transfer/transfer'

RSpec.describe QiwiObserver::Transfer do

  it "is not created without a wallet and token" do
    expect{described_class.new}.to raise_error ArgumentError
  end

  describe '#to_wallet' do
    before do
      QiwiObserver.config.wallet = "77002571291"
      QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
    end

    it 'returns ArgumentError without params' do
      transfer = described_class.new
      expect{transfer.to_wallet}.to raise_error ArgumentError
    end

    let(:file) {File.read('spec/qiwi_observer/fixtures/transfer.json').chomp}
    it 'if request success returns hash with transaction data' do
      stub_request(:post, "https://edge.qiwi.com/sinap/api/v2/terms/99/payments").
        with(
          body: file,
          headers: {
           'Accept'=>'application/json',
           'Authorization'=>'Bearer 35bf0ae0b5a2fdd8e29b1806ae7456d2',
           'Content-Type'=>'application/json'
          }
        ).
        to_return(status: 200, body: File.new('spec/qiwi_observer/fixtures/transfer_response.json'))
        transfer = described_class.new
        expect(transfer.to_wallet({account: '+79121112233', amount: 100.5})).to include(:comment, :fields, :id, :transaction)
    end
  end
end
