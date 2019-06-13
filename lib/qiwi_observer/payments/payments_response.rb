module QiwiObserver
  class PaymentsResponse < Response
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

    def short_info
      output = []
      hash = @value
      hash[:data].each do |tran|
        output << {
          account_id: tran[:account],
          amount: tran[:total][:amount],
          date: tran[:date],
          comment: tran[:comment]
        }
      end
      output
    end

    private

    def parse_body(body)
      JSON.parse(body, symbolize_names: true)
    end

    def error_description(body)
      'Error ' + body.join(' ')
    end

  end
end
