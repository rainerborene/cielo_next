require "hashie"

module Cielo
  class Response < Hashie::Mash
    disable_warnings

    def convert_key(key)
      key.to_s.underscore
    end
  end
end
