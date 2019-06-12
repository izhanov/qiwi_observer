module QiwiObserver
  class WebhookResult
    attr_reader :error, :value
    def initialize(success:, body:)
      @success = success
      if @success
        @value = parse_body(body)
      else
        @error = body
      end
    end

    def success?
      @success
    end

    private

    def parse_body(body)
      output = body[:payment]
      output.select { |key, val| key != :signFields }.to_h
    end
  end
end
