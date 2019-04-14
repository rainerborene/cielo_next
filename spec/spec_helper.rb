$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "cielo"
require "minitest/autorun"
require "vcr"
require "webmock"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes/cielo"
  config.hook_into :webmock
end

Cielo.configure do |config|
  config.merchant_id = "34c7e09a-12c9-47bc-9e13-612512786368"
  config.merchant_key = "HESCNUSLIPGQQHEWSEHSGBGGEJWUZEFWIWBYFUUF"
  config.environment = :sandbox
end
