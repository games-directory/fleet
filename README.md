# Request Relay

## Overview
Request Relay is a proof-of-concept application originally developed as a lightweight Sinatra script. Its primary function is to enable games.directory to route API requests through various servers, serving as a flexible middleware solution for managing cross-platform gaming interactions.

## Current State
In its present form, Request Relay (fleet.rb) is a basic implementation demonstrating the core concept. The script showcases the potential for a more robust, scalable solution for API request routing in gaming applications.

## Integration with games.directory
Request Relay has been incorporated into the games.directory ecosystem, providing essential functionality for managing cross-platform communications. This integration demonstrates the practical application of Request Relay's concepts in a real-world gaming environment.

## Future Vision
The long-term goal for Request Relay is to evolve from its current proof-of-concept state into a fully-fledged plugin or Engine. This transformation aims to create a versatile tool that can be seamlessly integrated into various applications, extending its utility beyond its original scope.

## Maintainability Considerations
The development and integration of Request Relay highlighted several key maintainability challenges:
1. Ongoing updates required to keep pace with changes in third-party APIs
2. The need for regular security audits and patches
3. Performance optimization to handle increasing load
4. Compatibility management across different gaming platforms and their evolving APIs

These factors contributed to the decision to integrate Request Relay's core functionality directly into games.directory, streamlining maintenance efforts and reducing overall operational costs.

## Planned Features (ToDo)
While the project's focus has shifted, the original roadmap included several key features:
* IP Rotator
* In-memory cache for tracking 3rd party API limits
* XBOX API capability
* STEAM API capability
* Epic API capability

## Legacy and Impact
Although Request Relay as a standalone project has been discontinued, its core concepts and learnings have been instrumental in shaping the architecture and capabilities of games.directory. The experience gained from Request Relay's development continues to influence cross-platform gaming communication strategies.
