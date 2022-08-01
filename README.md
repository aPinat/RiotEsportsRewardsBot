# RiotEsportsRewardsBot

Automatically farms rewards on lolesports.com without browser.

Personal use project, not made for public consumption.

Repo is only here for reference.

## Docker deployment

Automated container builds are pushed to [ghcr.io/apinat/riotesportsrewardsbot](https://github.com/aPinat/RiotEsportsRewardsBot/pkgs/container/riotesportsrewardsbot) with `latest`, `{BRANCH}`, `sha-{COMMIT_SHA}` available as tags.

### Environment Variables to Use

| ENV VAR Name | Description |
| --- |------------------------------------|
| RIOT_X_API_KEY | Personal API key from https://developer.riotgames.com |
| RIOT_ACCESS_TOKEN | Access Token gained from reading Network Transfer on https://lolesports.com |
| HL_TAG | Your Locale Tag provided by your Geolocation (this have to be ident with your geolocation) |
