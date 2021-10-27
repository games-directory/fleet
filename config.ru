# bundle exec rackup config.ru -p 4567

require './fleet'
run Sinatra::Application