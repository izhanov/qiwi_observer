module QiwiObserver
  class Webhook
    def initialize(key)
      raise ArgumentError, 'Secret key must be set' unless key
      @key = key
    end

    def call(params)
      if sign_correct?(params)
        return WebhookResponse.new(success: true, body: params)
      else
        return WebhookResponse.new(success: false, body: params.dig(:payment, :txnId))
      end
    end

    private

    def sign_correct?(params)
      sign_fields = "#{params.dig(:payment, :sum, :currency)}|#{params.dig(:payment, :sum, :amount)}|#{params.dig(:payment, :type)}|#{params.dig(:payment, :account)}|#{params.dig(:payment, :txnId)}"
      secret_key = Base64.decode64(@key)
      secure_hash = OpenSSL::HMAC.hexdigest('SHA256', secret_key, sign_fields)
      params[:hash] == secure_hash
    end
  end
end
