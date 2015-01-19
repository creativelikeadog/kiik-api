module Kiik

	class Wallet
    attr_reader :token, :site, :version
    attr_accessor :logger, :options

    def initialize(token,options={})
      @site = 'https://wallet.kiik.com.br'
      @version = 'v1'
      @token = token
      @ca_file = options.delete(:ca_file) || default_ca_file
      @logger = options.delete(:logger) || Kiik::Logger
      @options = options
      return true
    end

    def client
      @client ||= Kiik::Client.new(token,:site => { :url => site },:ssl => client_ssl_options)
    end

    def api
      @api ||= Kiik::Wallet::Client.new(self,options)
    end

    private
    def rest_client_ssl_options
      { :ssl_ca_file => @ca_file, :verify_ssl => OpenSSL::SSL::VERIFY_PEER }
    end

    def client_ssl_options
      { :ca_file => @ca_file, :verify => OpenSSL::SSL::VERIFY_PEER }
    end

    def default_ca_file
      File.join(File.dirname(__FILE__), 'cacert.pem')
    end

  end
end

# :nodoc: undo the clusterfuck that rest-client has done
if Net::HTTP.method_defined? :__request__
  module Net
    class HTTP
      undef request
      alias request __request__
    end
  end
end

