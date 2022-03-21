require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'oj'

class PewPewHTTP
  include HTTParty
  base_uri 'https://my.callofduty.com/api/papi-client'
  
  debug_output $stdout
end

class App < Sinatra::Base
  enable :logging

  set :server, :puma
  set :logging, true

  before do
    content_type :json
  end
  
  get '/' do
    json({ status: 200 })
  end

  # Call of Duty
  # 
  get '/pewpew/*' do
    url    = request.env['REQUEST_URI'].gsub('/pewpew/', '/')
    cookie = { 'Cookie' => request.env['HTTP_COOKIE'] }
    
    call = PewPewHTTP.get(url, headers: cookie) if request.env['REQUEST_METHOD'] == 'GET'
    call = PewPewHTTP.post(url, headers: cookie) if request.env['REQUEST_METHOD'] == 'POST'
    
    Oj.dump(call.parsed_response)
  end

  # Fortnite
  # 
  get '/floss/*' do
    json({ status: 200 })
  end
  
  # Fortnite
  # 
  get '/xbl/*' do
    json({ status: 200 })
  end
  
  # Fortnite
  # 
  get '/psn/*' do
    json({ status: 200 })
  end
  
  # Fortnite
  # 
  get '/steam/*' do
    json({ status: 200 })
  end
end

App.run!