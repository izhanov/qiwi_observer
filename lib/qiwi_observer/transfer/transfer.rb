module QiwiObserver
  class Transfer
    API_PATH = 'https://edge.qiwi.com/sinap/api/v2/terms/99/payments'
    def initialize
      @wallet = QiwiObserver.config.wallet
      @token = QiwiObserver.config.token
      raise ArgumentError, 'Wallet and token must be configure' if @wallet.nil? && @token.nil?
    end

    def to_wallet(args={})
      raise ArgumentError, 'Params must be set' unless !args.empty?
      uri = URI(API_PATH)

      request = Net::HTTP::Post.new(uri)
      request.initialize_http_header(
        {
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@token}"
        })
      request.body = body(args).to_json

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      response = http.request(request)
      JSON.parse(response.body, symbolize_names: true)
    end


    private

    def body(args)
      {
        "id" => "11111111111111",
        "sum" => {
          "amount" => args[:amount],
          "currency" => "643"
        },
        "paymentMethod" => {
          "type" => "Account",
          "accountId" => "643"
        },
        "comment" => "test",
        "fields" => {
          "account" => args[:account]
        }
      }
    end
  end
end
