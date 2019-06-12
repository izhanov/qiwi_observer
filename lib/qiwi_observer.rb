require 'net/http'
require "dry-configurable"
require 'base64'
require 'openssl'
require 'json'

require "qiwi_observer/version"
require 'qiwi_observer/payments'
require 'qiwi_observer/response'
require 'qiwi_observer/webhook'
require 'qiwi_observer/webhook_result'

module QiwiObserver
  extend Dry::Configurable

  setting :wallet
  setting :token
end
