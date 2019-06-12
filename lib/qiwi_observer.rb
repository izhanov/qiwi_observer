require 'net/http'
require "dry-configurable"

require "qiwi_observer/version"
require 'qiwi_observer/payments'
require 'qiwi_observer/webhook'

module QiwiObserver
  extend Dry::Configurable

  setting :wallet
  setting :token
end
