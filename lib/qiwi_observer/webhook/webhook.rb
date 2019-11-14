module QiwiObserver
  class Webhook
    def initialize(key)
      raise ArgumentError, "Secret key must be set" unless key

      @key = key
    end

    def call(params)
      return WebhookResponse.new(success: true, body: params) if params.dig(:test) == true
      return WebhookResponse.new(success: true, body: params) if sign_correct?(params)

      WebhookResponse.new(success: false, body: params.dig(:payment, :txnId))
    end

    private

    def sign_correct?(params)
      sign_fields = concat_sign_fields(params)
      secret_key = Base64.decode64(@key)
      secure_hash = OpenSSL::HMAC.hexdigest("SHA256", secret_key, sign_fields)
      params[:hash] == secure_hash
    end

    def concat_sign_fields(params)
      first_part = params.dig(:payment, :sum, :currency)
      second_part = params.dig(:payment, :sum, :amount)
      third_part = params.dig(:payment, :type)
      fourth_part = params.dig(:payment, :account)
      fifth_part = params.dig(:payment, :txnId)
      [first_part, second_part, third_part, fourth_part, fifth_part].join("|")
    end
  end
end
