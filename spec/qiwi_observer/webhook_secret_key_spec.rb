# frozen_string_literal: true

require "spec_helper"
require "./lib/qiwi_observer/webhook/webhook_secret_key"

RSpec.describe QiwiObserver::WebhookSecretKey do
  let(:token) {"3b7beb2044c4dd4a8f4588d4a6b6c93f"}
  let(:hook_id) {"5e2027d1-f5f3-4ad1-b409-058b8b8a8c22"}
  it "doesn't create without hook id" do
    expect{described_class.new()}.to raise_error(ArgumentError)
  end


  describe "#call" do
    before do
      QiwiObserver.config.token = token
    end

    context "when token is invalid" do
      it "return error 'Error 401 Unauthorized'" do
        stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}/key").
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
    context "when hook doesn't exists" do
      it "returns Error 404 Not Found" do
        stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}/key").
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

    context "when hook exists" do
      it "returns hook's secret key" do
        stub_request(:get, "https://edge.qiwi.com/payment-notifier/v1/hooks/#{hook_id}/key").
          with(
            headers: {
              "Accept" => "application/json",
              "Authorization" => "Bearer #{token}",
              "Content-Type" => "application/json"
            }).
          to_return(status: 200, body: File.new("spec/qiwi_observer/fixtures/secret_key.json"))
        operation = described_class.new(hook_id)
        result = operation.call
        expect(result.value).to include(:key)
      end
    end
  end
end
