module QiwiObserver
  class Payments
    API_PATH = "https://edge.qiwi.com/payment-history/v2/persons/".freeze

    def initialize
      @wallet = QiwiObserver.config.wallet
      @token = QiwiObserver.config.token

      raise ArgumentError, "Wallet and token must be configure" if @wallet.nil? && @token.nil?
    end

    def call(args = {})
      uri = linkage(args)
      request = prepare_a_request(uri)
      http = connect_to(uri)

      response = http.request(request)


      return PaymentsResponse.new(success: true, body: response.body) if response.is_a?(Net::HTTPOK)
      return PaymentsResponse.new(success: false, body: [response.code, response.message])
    end

    private

    def linkage(args)
      link = URI(API_PATH + "#{@wallet}/payments")
      link.query = URI.encode_www_form(args)
      link
    end

    def prepare_a_request(uri)
      request = Net::HTTP::Get.new(uri)
      request.initialize_http_header(
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@token}"
        }
      )
      request
    end

    def connect_to(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http
    end
  end
end
