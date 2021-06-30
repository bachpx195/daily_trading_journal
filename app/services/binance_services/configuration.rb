require "openssl"
require "base64"

module BinanceServices
  class Configuration
    class << self
      attr_writer :api_key, :locale, :read_info_api_key, :secret_key

      def api_key(type: nil)
        SystemConfig.find_by(key: "binance-api-key").value
      end

      def secret_key
        SystemConfig.find_by(key: "binance-api-secret").value
      end

      def signed_request_signature(payload:)
        raise "loi cmnr" unless secret_key
        digest = OpenSSL::Digest::SHA256.new
        OpenSSL::HMAC.hexdigest(digest, secret_key, payload)
      end

      def timestamp
        Time.now.utc.strftime("%s%3N")
      end
    end
  end
end