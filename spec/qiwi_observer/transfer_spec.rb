require 'spec_helper'
require './lib/qiwi_observer/transfer/transfer'

RSpec.describe QiwiObserver::Transfer do
  it "is not created without a wallet and token" do
    expect{described_class.new}.to raise_error ArgumentError
  end


  describe '#call' do
    before do
      QiwiObserver.config.wallet = 77002571217
      QiwiObserver.config.token = '35bf0ae0b5a2fdd8e29b1806ae7456d1'
    end

    describe "when arguments don't set" do
      it "raise ArgumentError" do
        expect{subject.call}.to raise_error ArgumentError
      end
    end

    describe "when arguments set" do
      it "" do

      end
    end
  end
end
