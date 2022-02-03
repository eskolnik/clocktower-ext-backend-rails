# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ## JWT AUTH
These endpoints are called by the Twitch extension, and require a signed JWT to function.

### GET /grimoires/
Loads the grimoire for a channelId based on JWT. Currently only capable of loading the broadcaster's view.

### GET /broadcasters/:channelId
Get a broadcaster's secret key. Used for config view only

### POST /broadcasters/
Update a broadcaster's secret key


## NO JWT AUTH
These endpoints are called by the bookmarklet on the Clocktower app, and only require the secret key.

### POST /grimoires/:secretKey
When a grimoire is received, we need to check the session,
see if anyone is currently streaming that session,
and publish updates to each of them.

### POST /sessions/:secretKey
Upsert a session record to assign a broadcaster to a specific session and player.
The `isActive` flag marks whether the session should be sent to the viewers (when false, overlay should show nothing).



