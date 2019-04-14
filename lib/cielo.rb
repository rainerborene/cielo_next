require "securerandom"
require "active_support/core_ext/module/attribute_accessors"
require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/hash/keys"

module Cielo
  autoload :API,        "cielo/api"
  autoload :Response,   "cielo/response"
  autoload :ReturnInfo, "cielo/return_info"
  autoload :Extensions, "cielo/extensions"

  mattr_accessor :merchant_id
  mattr_accessor :merchant_key
  mattr_accessor :environment

  module_function

  def configure
    yield self
  end

  def transaction_endpoints
    @transaction_endpoints ||= {
      sandbox: "https://apisandbox.cieloecommerce.cielo.com.br",
      production: "https://api.cieloecommerce.cielo.com.br"
    }
  end

  def query_endpoints
    @query_endpoints ||= {
      sandbox: "https://apiquerysandbox.cieloecommerce.cielo.com.br",
      production: "https://apiquery.cieloecommerce.cielo.com.br"
    }
  end

  def statuses
    @statuses ||= {
      not_finished: 0,
      authorized: 1,
      payment_confirmed: 2,
      denied: 3,
      voided: 10,
      refunded: 11,
      pending: 12,
      aborted: 13,
      scheduled: 20
    }
  end

  def brands
    @brands ||= [
      "Visa",
      "Master",
      "Amex",
      "Elo",
      "Aura",
      "JCB",
      "Diners",
      "Discover",
      "Hipercard"
    ]
  end

  def success?(code)
    statuses.values_at(:authorized, :payment_confirmed, :voided, :refunded, :pending, :scheduled).include?(code)
  end
end
