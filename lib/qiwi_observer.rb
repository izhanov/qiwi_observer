require 'net/http'
require "dry-configurable"
require 'base64'
require 'openssl'
require 'json'

require "qiwi_observer/version"
require 'qiwi_observer/response'
require 'qiwi_observer/payments/payments'
require 'qiwi_observer/payments/payments_response'
require 'qiwi_observer/webhook/webhook'
require 'qiwi_observer/webhook/webhook_response'
require 'qiwi_observer/transfer/transfer'

module QiwiObserver
  extend Dry::Configurable

  setting :wallet
  setting :token
end
