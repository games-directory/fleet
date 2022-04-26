require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'oj'
require 'pry'

class PewPewHTTP
  include HTTParty
  base_uri 'https://my.callofduty.com/api/papi-client'
  
  debug_output $stdout
end

class TrnHTTP
  include HTTParty
  base_uri 'https://api.tracker.gg/api/v2'
  
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
    cookie = {
      'Cookie' => request.env['HTTP_COOKIE']
    }
    
    call = PewPewHTTP.get(url, headers: cookie) if request.env['REQUEST_METHOD'] == 'GET'
    call = PewPewHTTP.post(url, headers: cookie) if request.env['REQUEST_METHOD'] == 'POST'
    
    Oj.dump(call.parsed_response)
  end

  # TrackerNertwork
  # 
  get '/trn/*' do
    url = request.env['REQUEST_URI'].gsub('/trn/', '/')

    user_agents = [
      'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16D57',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      'Mozilla/5.0 (iPad; CPU OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1'
    ]

    response = `curl -s \
      -X GET 'https://api.tracker.gg/api/v2#{ url }' \
      -H 'Host: api.tracker.gg' \
      -H 'User-Agent: #{ user_agents.sample }' \
      -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
      -H 'Accept-Language: en-US,en;q=0.5' \
      -H 'Referer: https://api.tracker.gg' \
      -H 'Cookie: all required cookies will appear here' \
      -H 'Connection: keep-alive' --compressed
    `

    response
  end

  # Fortnite
  # 
  get '/floss/*' do
    json({ status: 200 })
  end
  
  # Xbox Live
  # 
  get '/xbl/*' do
    json({ status: 200 })
  end
  
  # PlayStation
  # 
  get '/psn/*' do
    json({ status: 200 })
  end
  
  # Steam
  # 
  get '/steam/*' do
    json({ status: 200 })
  end
end

App.run!