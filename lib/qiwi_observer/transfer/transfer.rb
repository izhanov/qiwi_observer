module QiwiObserver
  class Transfer
    def initialize(wallet: QiwiObserver.config.wallet, token: QiwiObserver.config.token)
      raise ArgumentError, 'Wallet and token must be set' unless wallet && token
      @wallet = wallet
      @token = token
    end

    def call(kind, amount: '', account: '')
      raise ArgumentError, 'Type transfer, amount and account must be set' unless kind && amount != '' && account != ''

    end
  end
end
