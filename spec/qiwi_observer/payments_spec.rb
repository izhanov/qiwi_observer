require 'spec_helper'
require './lib/qiwi_observer/payments'

RSpec.describe QiwiObserver::Payments do

  it "is not created without a wallet and token" do
    expect{described_class.new}.to raise_error ArgumentError
  end

  it "is create with wallet and token" do
    payments = described_class.new(
      wallet: '77002571217',
      token: '35bf0ae0b5a2fdd8e29b1806ae7456d1'
    )
    expect(payments).to be_instance_of(described_class)
  end

  describe "#call" do
    context "when arguments don't set" do
      it "returns with 'Error 422 Unprocessable Entity' message " do
        payments = described_class.new(
          wallet: '77002571217',
          token: '35bf0ae0b5a2fdd8e29b1806ae7456d1'
        ).call
        expect(payments.error).to eq('Error 422 Unprocessable Entity')
      end
    end

    context "when arguments set" do
      it "returns hash with :data, :nextTxnId & :nextTxnDate keys" do
        payments = described_class.new(
          wallet: '77002571217',
          token: '35bf0ae0b5a2fdd8e29b1806ae7456d1'
        ).call({rows: 10})
        expect(payments.value).to include(:data, :nextTxnId, :nextTxnDate)
      end

      context "when token is not correct" do
        it "returns with 'Error 401 Unauthorized' message " do
          payments = described_class.new(
            wallet: '77002571217',
            token: '35bf0ae0b5a2fdd8e29b1806ae7456d2'
          ).call({rows: 10})
          expect(payments.error).to eq('Error 401 Unauthorized')
        end
      end

      context "when wallet is not correct" do
        it "returns with 'Error 403 Forbidden' message " do
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
