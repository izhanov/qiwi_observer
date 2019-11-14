# frozen_string_literal: true

module QiwiObserver
  class WebhookRegistration
    def initialize(url)
      @token = QiwiObserver.config.token
      @url = url

      raise ArgumentError, "Token must be configure in QiwiObserver" if @token.nil?
      raise ArgumentError, "URL must be set" unless url
    end

    def call
      query = URI.encode_www_form({hookType: 1, param: @url, txnType: "2"})
      uri = URI("https://edge.qiwi.com/payment-notifier/v1/hooks?#{query}")
      request = prepare_a_request(uri)
      http = connect_to_api(uri)
      response = http.request(request)
      return WebhookResponse.new(success: true, body: response.body) if response.is_a?(Net::HTTPOK)
      return WebhookResponse.new(success: false, body: [response.code, response.message])
    end

    private

    def prepare_a_request(uri)
      request = Net::HTTP::Put.new(uri)
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
