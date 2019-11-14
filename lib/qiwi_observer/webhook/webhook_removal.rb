# frozen_string_literal: true

module QiwiObserver
  class WebhookRemoval
    def initialize(hook_id)
      @token = QiwiObserver.config.token
      @hook_id = hook_id

      raise ArgumentError, "QiwiObserver must be configure with token" if @token.nil?
      raise ArgumentError, "Hook ID must be set" unless hook_id
    end

    def call
      uri = URI("https://edge.qiwi.com/payment-notifier/v1/hooks/#{@hook_id}")
      request = prepare_a_request(uri)
      http = connect_to_api(uri)
      response = http.request(request)
      return WebhookResponse.new(success: true, body: response.body) if response.is_a?(Net::HTTPOK)
      return WebhookResponse.new(success: false, body: [response.code, response.message])
    end

    private

    def prepare_a_request(uri)
      request = Net::HTTP::Delete.new(uri)
      request.initialize_http_header(
        {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{@token}"
        }
      )
      request
    end

    def connect_to_api(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end
