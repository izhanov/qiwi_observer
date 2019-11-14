# frozen_string_literal: true

require "spec_helper"
require "./lib/qiwi_observer/webhook/webhook_removal"

RSpec.describe QiwiObserver::WebhookRemoval do
  let(:token) { "35bf0ae0b5a2fdd8e29b1806ae7456d2" }
  let(:hook_id) { "d63a8729-f5c8-486f-907d-9fb8758afcfc" }

  context "when QiwiObserver doesn't configure" do
    it "returns ArgumentError" do
      expect{described_class.new}.to raise_error(ArgumentError)
    end
  end

  context "when hook id doesn't set" do
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
      before do
        QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
        QiwiObserver.config.wallet = "77774889669"
      end

      it "returns Error 401 Unauthorized" do
        stub_request(:delete, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: [401, 'Unauthorized'])

        operation = described_class.new(hook_id)
        result = operation.call
        expect(result.error).to eq("Error 401 Unauthorized")
      end
    end

    context "when token is valid" do
      before do
        QiwiObserver.config.token = "35bf0ae0b5a2fdd8e29b1806ae7456d2"
        QiwiObserver.config.wallet = "77774889669"
      end

      it "returns response with message" do
        stub_request(:delete, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: 200, body: File.new("spec/qiwi_observer/fixtures/hook_deleted_response.json"))

        operation = described_class.new(hook_id)
        result = operation.call
        expect(result.value).to include(response: "Hook deleted")
      end

      context "when hook already deleted" do
      it "returns Error 404 Not Found" do
        stub_request(:delete, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: [404, "Not Found"])

        operation = described_class.new(hook_id)
        result = operation.call
        expect(result.error).to eq("Error 404 Not Found")
      end
    end
    end
  end
end
