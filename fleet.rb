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

    @@requests ||= 0
    @@resets_at ||= Time.now + 3600

    # I don't think this is the best approach. This data resets, regardless of the 3rd party API status, whenever
    # the script is run,
    # If we don't add some sort of in-memory cache, like Redis, we will have to use games.directory instead, send
    # a POST each time and store the values in there.
    # 
    if Time.now > @@resets_at
      @@requests = 0
      @@resets_at = Time.now + 3600
    end

    @@current_request_path = request.env['REQUEST_URI']
    @@requests += 1

    if @@requests >= 150
      halt 429, {
        error: 'Too many requests',
        message: "You have made #{ @@requests } so far. Please try again later.",
        resets_at: @@resets_at
      }.to_json
    end

    HTTP.headers('Authorization' => request.env['HTTP_AUTHORIZATION']) rescue nil
  end

  get '/heartbeat' do
    HTTParty.get('https://games.directory/heartbeat',
      headers: {
        'User-Agent' => 'Fleet/1.0 (compatible; FleetBot/1.0; https://github.com/games-directory/fleet; info@games.directory'
      }
    )
  end

  get '/stats' do
    {
      requests: @@requests,
      resets_at: @@resets_at
    }.to_json
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