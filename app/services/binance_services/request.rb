require 'httparty'

module BinanceServices
  class Request
    include HTTParty
    class << self
      def send!(headers: {}, method: :get, path: "/", params: {})
        self.base_uri "https://api3.binance.com"

        all_headers = default_headers
        params.delete_if { |k, v| v.nil? }
        signature = signed_request_signature(params: params)
        params.merge!(signature: signature)
        # send() is insecure so don't use it.
        binding.pry
        case method
        when :get
          response = get(path, headers: all_headers, query: params)
        when :post
          response = post(path, query: params, headers: all_headers)
        when :put
          response = put(path, query: params, headers: all_headers)
        when :delete
          response = delete(path, query: params, headers: all_headers)
        else
          raise "loi"
        end
        process!(response: response || "{}")
      end

      private

      def default_headers
        headers = {}
        headers["Content-Type"] = "application/json; charset=utf-8"
        headers["X-MBX-APIKEY"] =  BinanceServices::Configuration.api_key
        headers
      end

      def process!(response:)
        binding.pry
        json = begin
            JSON.parse(response.body, symbolize_names: true)
          rescue JSON::ParserError => error
            raise "loi"
          end
        raise "loi"
        json
      end

      def signed_request_signature(params:)
        payload = params.map { |key, value| "#{key}=#{value}" }.join("&")
        BinanceServices::Configuration.signed_request_signature(payload: payload)
      end
    end
  end
end