module QiwiObserver
  class WebhookResponse < Response
    attr_reader :error, :value
    def initialize(success:, body:)
      @success = success
      if @success
        @value = parse_body(body)
      else
        @error = error_description(body)
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

    def error_description(body)
      "This ##{body} transaction is not authenticated"
    end
  end
end
