Fleet is a little Sinatra script that allows games.directory to route API requests through different servers.

In it's current state, fleet.rb is very much basic, but the plan is to transform this script into a fully fledged plugin or Engine that can be added into any application.

ToDo

- IP Rotator
- In memory cache for keeping track of 3rd party API limits

- XBOX API capability
- STEAM API capability
- Epic API capability