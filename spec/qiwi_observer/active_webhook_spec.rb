# frozen_string_literal: true

require "spec_helper"
require "./lib/qiwi_observer/webhook/active_webhook"

RSpec.describe QiwiObserver::ActiveWebhook do
  context "when QiwiObserver doesn't configure with token" do
    it "doesn't create without token" do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end
  end

  describe "#call" do
    let(:token) { "35bf0ae0b5a2fdd8e29b1806ae7456d2" }

    before do
      QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
      QiwiObserver.config.wallet = "77002571291"
    end

    context "when token is invalid" do
      it "return error 'Error 401 Unauthorized'" do
        stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/active").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: [401, 'Unauthorized'])

        operation = described_class.new
        result = operation.call
        expect(result.error).to eq("Error 401 Unauthorized")
      end
    end

    context "when token is valid" do
      context "webhook not registred" do
        it "returns Error 404 Not Found" do
          stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/active").
            with(
              headers: {
                "Accept" => "application/json",
                "Authorization" => "Bearer #{token}",
                "Content-Type" => "application/json"
              }).
            to_return(status: [404, 'Not Found'])
            operation = described_class.new
            result = operation.call
            expect(result.error).to eq("Error 404 Not Found")
        end
      end

      context "webhook is registred" do
        it "returns registred hook id" do
          stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/active").
            with(
              headers: {
                "Accept" => "application/json",
                "Authorization" => "Bearer #{token}",
                "Content-Type" => "application/json"
              }).
            to_return(status: 200, body: File.new("spec/qiwi_observer/fixtures/webhook_registered.json"))
            operation = described_class.new
            result = operation.call
            expect(result.value).to include(:hookParameters, hookId: "5e2027d1-f5f3-4ad1-b409-058b8b8a8c22")
        end
      end
    end
  end
end
