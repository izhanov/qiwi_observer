# frozen_strong_literal: true

require "spec_helper"
RSpec.describe QiwiObserver do
  it "has a version number" do
    expect(QiwiObserver::VERSION).not_to eq nil
  end

  context "QiwiObserver must be configure" do
    before do
      QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
      QiwiObserver.config.wallet = "77774889669"
    end

    it "with token" do
      expect(QiwiObserver.config.token).not_to eq nil
    end

    it "with wallet" do
      expect(QiwiObserver.config.wallet).not_to eq nil
    end
  end
end
