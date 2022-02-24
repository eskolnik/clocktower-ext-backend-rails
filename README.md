# Paperweight Clocktower Backend
This is the backend of a Twitch extension for streamed games of Blood on the Clocktower.

This extension is designed to be used in conjunction with the unofficial [Townsquare](https://clocktower.online/) web app. 

# Endpoints

## JWT AUTH
These endpoints are called by the Twitch extension, and require a signed JWT to function.

### GET /grimoires/:channel_id
Loads the grimoire for a channelId based on JWT. Currently only capable of loading the broadcaster's view.

### GET /broadcasters/:channel_id
Get a broadcaster's secret key. Used for config view only
    
### POST /broadcasters
Update a broadcaster's secret key


## NO JWT AUTH
These endpoints are called by the bookmarklet on the Clocktower app, and only require the secret key.

### POST /grimoires
When a grimoire is received, we need to check the session,
see if anyone is currently streaming that session,
and publish updates to each of them.

### POST /sessions
Upsert a session record to assign a broadcaster to a specific session and player.
The `isActive` flag marks whether the session should be sent to the viewers (when false, overlay should show nothing).

# Development
`rails s` 

# Deploy

`cap production deploy`

With backtrace:
`cap production deploy --trace`

Dry run:
`cap production deploy -n`

## Acknowledgements and Copyrights
* [Blood on the Clocktower](https://bloodontheclocktower.com/) is a trademark of Steven Medway and [The Pandemonium Institute](https://www.thepandemoniuminstitute.com/)
* Unofficial [Townsquare](https://github.com/bra1n/townsquare) application by [bra1n](https://github.com/bra1n)
* Webfonts by [Google Fonts](https://fonts.google.com/)
* All other images and icons are copyright to their respective owners

This project and its website are provided free of charge and not affiliated with The Pandemonium Institute in any way.