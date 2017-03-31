module Bitmovin
  class Client
    attr_accessor :api_key
    attr_accessor :base_url

    def initialize(config)
      @api_key = config[:api_key]
      @base_url = "https://api.bitmovin.com/v1"

      client_logger = Logger.new("bitmovin-client.log")
      client_logger.level = Logger::DEBUG

      @conn = Faraday.new(url: @base_url, headers: {
          'X-Api-Key' => @api_key,
          'X-Api-Client-Version' => Bitmovin::VERSION,
          'X-Api-Client' => 'bitmovin-ruby',
          'Content-Type' => 'application/json'
        }) do |faraday|

        faraday.request :json
        # faraday.response :logger
        faraday.response :detailed_logger, client_logger
        faraday.adapter :httpclient do |client| # yields HTTPClient
          client.keep_alive_timeout = 90
          client.ssl_config.timeout = 90
        end
        faraday.response :raise_error
      end
    end

    def get(*args, &block)
      @conn.get *args, &block
    end

    def delete(*args, &block)
      @conn.delete *args, &block
    end

    def post(*args, &block)
      @conn.post *args, &block
    end
  end
end
