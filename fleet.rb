require 'sinatra'
require 'sinatra/reloader'

require 'oj'
require 'httparty'

class HTTP
  include HTTParty
  base_uri 'https://m.np.playstation.net/api'

  headers 'Accept-Language' => 'en-US'
  headers 'User-Agent' => 'Mozilla/5.0 (PlayStation 5 3.03/SmartTV) AppleWebKit/605.1.15 (KHTML, like Gecko)'
end

class PlayStation < Sinatra::Base
  set :server, 'thin'
  set :logging, true

  configure :development do
    register Sinatra::Reloader
  end

  before do
    content_type :json

    @@current_request_path = request.env['REQUEST_URI']

    HTTP.headers('Authorization' => request.env['HTTP_AUTHORIZATION']) rescue nil
  end

  # Proof of concept. Might be a bulletproof solution without having to replicate every single endpoint
  # point we want to access. Every gem we currently use in games.directory defines its own routes, params
  # and the authentication credentials and sends them in the request.
  # 
  # With this in place, Sinatra will catch anything we throw at him and send the request out. The only thing
  # we need to do is ensure we pass the authentication, coming from the gem, along with the request.
  # 
  get '/*' do
    Oj.dump(HTTP.get(@@current_request_path).parsed_response)
  end
end

PlayStation.run!