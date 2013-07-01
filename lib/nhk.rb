require 'nhk/version'
require 'date'
require 'net/http'
require 'json'

module NHK

  CREDIT = {ja: {independent: '情報提供:ＮＨＫ', use_something_together: 'ＮＨＫ番組情報の提供:ＮＨＫ'}}

  class RequestError < StandardError; end

  class Schedule

    @@options = {
    	version: 'v1',
    	area: '',
    	apikey: '',
      date: Date.today.to_s
    }

    def self.options
      @@options
    end

    def self.options=(opts)
      @@options = opts
    end

    def self.send_request(query)
      request_url = "http://api.nhk.or.jp/#{@@options[:version]}/pg" + query + "?key=#{@@options[:apikey]}"
      res = Net::HTTP.get_response(URI::parse(request_url))

      unless res.kind_of? Net::HTTPSuccess
        raise NHK::RequestError, "HTTP Response: #{res.code} #{res.message}\nRequest URL:#{request_url}"
      end

      JSON::parse res.body
    end

    def self.program_list(area = @@options[:area], date = @@options[:date], service)
      send_request("/list/#{area}/#{service}/#{date}\.json") 
    end

    def self.program_genre(area = @@options[:area], date = @@options[:date], genre)
      send_request("/genre/#{area}/#{genre}/#{date}\.json") 
    end

    def self.program_info(area = @@options[:area], id)
      send_request "/info/#{area}/#{id}\.json"
    end

    def self.now_on_air(area = @@options[:area], service)
      send_request "/now/#{area}/#{service}\.json"
    end

  end
end
