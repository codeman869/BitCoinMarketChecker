#!/usr/bin/env ruby
require 'httparty'
require 'csv'
APP_NAME = 'BitCoin Market Checker'

class BitCoin
    include HTTParty
    base_uri "http://api.bitcoincharts.com/"
    headers "User-agent" => APP_NAME
end

class Error404 < StandardError
end

class NoResponseError < StandardError
end

def getMarketValues(market, currency)
    response = BitCoin.get('/v1/trades.csv', :query => {:symbol => market+currency})

    begin
        raise NoResponseError if response.nil?
        raise Error404 if response.code == 404
        parsed_resp = CSV.parse(response)[0]
        parsed_resp[1].to_f
    rescue NoResponseError => e
        puts e.message
        puts "No response received from server"
        
    rescue Error404 => e
        puts e.message
        puts "Received a 404 response from server"
    end
    
end

puts getMarketValues("rock","USD")