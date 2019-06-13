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
      if body[:test] != true
        output = body[:payment]
        return output.select { |key, val| key != :signFields }.to_h
      else
        return body
      end
    end

    def error_description(body)
      "This ##{body} transaction is not authenticated"
    end
  end
end
