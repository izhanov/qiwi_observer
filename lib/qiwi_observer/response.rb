require 'json'
module QiwiObserver
  class Response
    attr_reader :value, :error

    def initialize(success:, body:)
      @success = success

      if @success
        @value = json_parse(body)
      else
        @error = error_description(body)
      end
    end

    def success?
      @succesess
    end

    private

    def json_parse(body)
      JSON.parse(body, symbolize_names: true)
    end

    def error_description(body)
      'Error ' + body.join(' ')
    end
  end
end
