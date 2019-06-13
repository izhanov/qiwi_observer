module QiwiObserver
  class Response
    attr_reader :value, :error

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
      raise NotImplementedError
    end

    def error_description(body)
      raise NotImplementedError
    end

  end
end
