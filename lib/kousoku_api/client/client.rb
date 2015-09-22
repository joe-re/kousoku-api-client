require 'rexml/document'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'

module KousokuApi
  class Client
    API_PATH = 'http://kosoku.jp/api/'

    def initialize
      @http_cli = Faraday.new(url: API_PATH)
    end

    def get(params = {})
      Hash.from_xml(@http_cli.get('route.php', to_request_params(params)).body)
    end

    private

    def to_request_params(hash)
      hash.each_with_object({}) do |(k, v), request_params|
        param = case k.to_sym
                when :start_ic then { f: v }
                when :end_ic then { t: v }
                when :type then { c: v }
                when :sort_by then { sortBy: v }
                else  { k: v }
                end
        request_params.merge param
      end || {}
    end
  end
end
