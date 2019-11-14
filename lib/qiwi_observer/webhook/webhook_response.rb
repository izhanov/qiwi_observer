# frozen_string_literal: true

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
      return parse_hash(body) if body.is_a?(Hash)
      return parse_json(body) if body.is_a?(String)
    end

    def error_description(body)
      return "This ##{body} transaction is not authenticated" if body.is_a?(String)
      return "Error #{body.first} #{body.last}" if body.is_a?(Array)
    end

    def parse_hash(body)
      if body[:test] != true
        output = body[:payment]
        output.reject { |key, _val| key == :signFields }.to_h
      else
        body
      end
    end

    def parse_json(body)
      output = JSON.parse(body).reduce({}) {|result, (key, value)| result.merge({key.to_sym => value})}
    end
  end
end
