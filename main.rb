     
require 'stock_quote'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/json'
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/quote/:symbol' do
  stock = StockQuote::Stock.json_quote("#{params[:symbol]}")
  content_type :json
  stock.to_json
end

# This gem does not have history for ASX stocks
get '/history/:symbol' do
  # get the date of last week
  d = (Date.today - 28).to_s.split('-').reverse.join('-')
  history = StockQuote::Stock.json_history("asx:#{params[:symbol]}", d)
  content_type :json
  history.to_json
end

options "*" do
  response.headers["Allow"] = "GET, POST, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token"
  response.headers["Access-Control-Allow-Origin"] = "*"
  200
end


