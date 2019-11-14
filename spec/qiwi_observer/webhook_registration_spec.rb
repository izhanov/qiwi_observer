# frozen_string_literal: true

require "spec_helper"
require "./lib/qiwi_observer/webhook/webhook_registration"

RSpec.describe QiwiObserver::WebhookRegistration do
  context "when QiwiObserver doesn't configure" do
    it "returns ArgumentError" do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
  end

  context "when url path doesn't set" do
    before do
      QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
      QiwiObserver.config.wallet = "77774889669"
    end

    it "returns ArgumentError" do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
  end

  describe "#call" do
    context "when token is invalid" do
      let(:query) { "hookType=1&param=http\%3A\%2F\%2Fecho.fjfalcon.ru\%2F&txnType=2" }
      let(:token) { "35bf0ae0b5a2fdd8e29b1806ae7456d2" }
      let(:uri) { "http://echo.fjfalcon.ru/" }

      before do
        QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
        QiwiObserver.config.wallet = "77774889669"
      end
      it "returns Error 401 Unauthorized" do
        stub_request(:put, "https://edge.qiwi.com/payment-notifier/v1/hooks?#{query}").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: [401, 'Unauthorized'])

        operation = described_class.new(uri)
        result = operation.call
        expect(result.error).to eq("Error 401 Unauthorized")
      end
    end

    context "when token is valid" do
      let(:query) { "hookType=1&param=http\%3A\%2F\%2Fecho.fjfalcon.ru\%2F&txnType=2" }
      let(:token) { "35bf0ae0b5a2fdd8e29b1806ae7456d2" }
      let(:uri) { "http://echo.fjfalcon.ru/" }

      before do
        QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
        QiwiObserver.config.wallet = "77774889669"
      end

      it "returns hook's credentials" do
        stub_request(:put, "https://edge.qiwi.com/payment-notifier/v1/hooks?#{query}").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: 200, body: File.new("spec/qiwi_observer/fixtures/webhook_registered.json"))

        operation = described_class.new(uri)
        result = operation.call
        expect(result.value).to include(:hookParameters, hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22")
      end

      context "when webhook already exist" do
        let(:query) { "hookType=1&param=http\%3A\%2F\%2Fecho.fjfalcon.ru\%2F&txnType=2" }
        let(:token) { "35bf0ae0b5a2fdd8e29b1806ae7456d2" }
        let(:uri) { "http://echo.fjfalcon.ru/" }

        before do
          QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
          QiwiObserver.config.wallet = "77774889669"
        end
        it "returns Error 422 Unprocessable Entity" do
          stub_request(:put, "https://edge.qiwi.com/payment-notifier/v1/hooks?#{query}").
            with(
              headers: {
                "Accept" => "application/json",
                "Authorization" => "Bearer #{token}",
                "Content-Type" => "application/json"
              }).
            to_return(status: [422, "Unprocessable Entity"])

          operation = described_class.new(uri)
          result = operation.call
          expect(result.error).to eq("Error 422 Unprocessable Entity")
        end
      end
    end
  end
end
