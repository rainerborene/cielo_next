require "faraday"
require "faraday_middleware"

module Cielo
  class API
    using Extensions

    attr_reader :environment

    delegate :get, :post, :put, to: :@connection

    def initialize(merchant_id = nil, merchant_key = nil, environment = nil, logger: nil)
      @environment = environment || Cielo.environment || :sandbox
      @connection = Faraday.new transaction_url do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.response :logger, logger, bodies: true if logger
        conn.adapter :net_http
        conn.headers["MerchantId"] = merchant_id || Cielo.merchant_id
        conn.headers["MerchantKey"] = merchant_key || Cielo.merchant_key
        conn.headers["RequestId"] = SecureRandom.uuid
      end
    end

    def find_by_payment(id)
      response = get do |req|
        req.url query_url("/1/sales/#{id}")
      end
      Response.new response.body
    end

    def find_payments_by_order(id)
      response = get do |req|
        req.url query_url("/1/sales")
        req.params["merchantOrderId"] = id
      end
      Response.new response.body
    end

    def create_sale(params = {})
      params.camelize_keys!
      handle_response post("/1/sales", params)
    end

    def capture_sale(id)
      handle_response put("/1/sales/#{id}/capture")
    end

    def cancel_sale(id)
      handle_response put("/1/sales/#{id}/void")
    end

    def deactivate_recurrent_payment(id)
      handle_response put("/1/RecurrentPayment/#{id}/Deactivate")
    end

    def update_recurrent_payment(id, params = {})
      params.camelize_keys!
      handle_response put("/1/RecurrentPayment/#{id}/Payment", params)
    end

    private

    def query_url(path)
      "#{Cielo.query_endpoints[environment]}#{path}"
    end

    def transaction_url
      Cielo.transaction_endpoints[environment]
    end

    def handle_response(response)
      return true if response.body.empty? && response.success?

      status = response.body.seek(["Payment", "Status"], "Status", [0, "Code"])

      if !response.success? || !Cielo.success?(status)
        code = response.body.seek(["Payment", "ReturnCode"], [0, "Code"])
        message = Cielo::ReturnInfo.fetch(code)
        message ||= response.body.seek(["Payment", "ReturnMessage"], [0, "Message"])

        raise Faraday::Error::ClientError.new(message, response)
      end

      Response.new response.body
    end
  end
end
