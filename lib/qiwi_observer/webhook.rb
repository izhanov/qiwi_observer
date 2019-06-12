require 'base64'
require 'openssl'

require_relative './webhook_result'

module QiwiObserver
  class Webhook
    def initialize(key)
      raise ArgumentError, 'Secret key must be set' unless key
      @key = key
    end

    def call(params)
      if sign_correct?(params)
        return result = WebhookResult.new(success: true, body: params)
      else
        return result = WebhookResult.new(success: false, body: params[:errorCode])
      end
    end

    private

    def sign_correct?(params)
      sign_fields = params[:payment][:sum][:currency].to_s + '|' + params[:payment][:sum][:amount].to_s + '|' + params[:payment][:type] + '|' + params[:payment][:account] + '|' + params[:payment][:txnId]
      secret_key = Base64.decode64(@key)
      secure_hash = OpenSSL::HMAC.hexdigest('SHA256', secret_key, sign_fields)
      params[:hash] == secure_hash
    end
  end
end
