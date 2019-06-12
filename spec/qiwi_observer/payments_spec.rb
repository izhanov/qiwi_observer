require 'spec_helper'
require './lib/qiwi_observer/payments'

RSpec.describe QiwiObserver::Payments do

  it "is not created without a wallet and token" do
    expect{described_class.new}.to raise_error ArgumentError
  end

  it "is create with wallet and token" do
    payments = described_class.new(
      wallet: '77002571218',
      token: '35bf0ae0b5a2fdd8e29b1806ae7456d2'
    )
    expect(payments).to be_instance_of(described_class)
  end

  describe "#call" do
    context "when arguments don't set" do
      it "returns with 'Error 422 Unprocessable Entity' message " do
        stub_request(:get, "https://edge.qiwi.com/payment-history/v2/persons/77002571218/payments").
          with(
            headers: {
           'Accept'=>'application/json',
           'Authorization'=>'Bearer 35bf0ae0b5a2fdd8e29b1806ae7456d2',
           'Content-Type'=>'application/json'
            }).
          to_return(status: [422, 'Unprocessable Entity'])
        payments = described_class.new(
          wallet: '77002571218',
          token: '35bf0ae0b5a2fdd8e29b1806ae7456d2'
        ).call
        expect(payments.error).to eq('Error 422 Unprocessable Entity')
      end
    end

    context "when arguments set" do
      it "returns hash with :data, :nextTxnId & :nextTxnDate keys" do
        stub_request(:get, "https://edge.qiwi.com/payment-history/v2/persons/77774889669/payments?rows=10").
          with(
            headers: {
           'Accept'=>'application/json',
           'Authorization'=>'Bearer 3ef97bca7bf63c78a94898326485a6c8',
           'Content-Type'=>'application/json'
            }).
          to_return(status: 200, body: File.new('spec/qiwi_observer/fixtures/payments.json'))
        payments = described_class.new(
          wallet: '77774889669',
          token: '3ef97bca7bf63c78a94898326485a6c8'
        ).call({rows: 10})
        expect(payments.value).to include(:data, :nextTxnId, :nextTxnDate)
      end

      context "when token is not correct" do
        it "returns with 'Error 401 Unauthorized' message " do
          stub_request(:get, "https://edge.qiwi.com/payment-history/v2/persons/77002571217/payments?rows=10").
            with(
              headers: {
             'Accept'=>'application/json',
             'Authorization'=>'Bearer 35bf0ae0b5a2fdd8e29b1806ae7456d2',
             'Content-Type'=>'application/json'
              }).
            to_return(status: [401, 'Unauthorized'])
          payments = described_class.new(
            wallet: '77002571217',
            token: '35bf0ae0b5a2fdd8e29b1806ae7456d2'
          ).call({rows: 10})
          expect(payments.error).to eq('Error 401 Unauthorized')
        end
      end

      context "when wallet is not correct" do
        it "returns with 'Error 403 Forbidden' message " do
          stub_request(:get, "https://edge.qiwi.com/payment-history/v2/persons/77002571219/payments?rows=10").
            with(
              headers: {
             'Accept'=>'application/json',
             'Authorization'=>'Bearer 35bf0ae0b5a2fdd8e29b1806ae7456d1',
             'Content-Type'=>'application/json'
              }).
            to_return(status: [403, 'Forbidden'])
          payments = described_class.new(
            wallet: '77002571219',
            token: '35bf0ae0b5a2fdd8e29b1806ae7456d1'
          ).call({rows: 10})
          expect(payments.error).to eq('Error 403 Forbidden')
        end
      end
    end
  end
end
