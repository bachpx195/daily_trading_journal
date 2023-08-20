require 'httparty'

module BinanceServices
  class Request
    include HTTParty
    class << self
      def send!(headers: {}, method: :get, path: "/", params: {})
        self.base_uri "https://api3.binance.com"
        all_headers = default_headers
        params.delete_if { |k, v| v.nil? }
        # signature = signed_request_signature(params: params)
        # params.merge!(signature: signature)
        # send() is insecure so don't use it.
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
          response = nil
          raise "loi"
        end
        write_api_log(path, nil, response, method, params)

        process!(response: response || "{}")
      end

      def write_api_log uri, request_body, response, request_method, params
        logger = Logger.new Rails.root.join("log", "binance_request_n_response.log")
        logger.info "--===::START::===--"
        logger.info "Endpoint: #{uri}"
        logger.info "Method: #{request_method}"
        logger.info "Params: #{params}"
        logger.info "Body: #{request_body}" if request_body.present?
        logger.info "Status code: #{response.code}"
        logger.info "Response: #{JSON.parse(response.body)&.map{|x| Time.at(x[0]/1000).to_datetime.strftime("%d/%m/%Y %H:%M:%S") }}" if response.body.present?
        logger.info "--===::END::===--\n"
      end

      private
      def default_headers
        headers = {}
        headers["Content-Type"] = "application/json; charset=utf-8"
        headers["X-MBX-APIKEY"] =  BinanceServices::Configuration.api_key
        headers
      end

      def process!(response:)
        json = begin
            JSON.parse(response.body)
          rescue JSON::ParserError => error
            raise "loi"
          end
        json
      end

      def signed_request_signature(params:)
        payload = params.map { |key, value| "#{key}=#{value}" }.join("&")
        BinanceServices::Configuration.signed_request_signature(payload: payload)
      end
    end
  end
end
