using System;
using System.Collections.Generic;
using Newtonsoft.Json;

namespace RiotEsportsRewardsBot.EventDetailsData
{
    public class EventDetailsData
    {
        [JsonProperty("data")] public Data? Data { get; set; }
    }

    public class Data
    {
        [JsonProperty("event")] public Event? Event { get; set; }
    }

    public class Event
    {
        [JsonProperty("id")] public string? Id { get; set; }

        [JsonProperty("type")] public string? Type { get; set; }

        [JsonProperty("tournament")] public Tournament? Tournament { get; set; }

        [JsonProperty("league")] public League? League { get; set; }

        [JsonProperty("match")] public Match? Match { get; set; }

        [JsonProperty("streams")] public List<Stream>? Streams { get; set; }
    }

    public class League
    {
        [JsonProperty("id")] public string? Id { get; set; }

        [JsonProperty("slug")] public string? Slug { get; set; }

        [JsonProperty("image")] public Uri? Image { get; set; }

        [JsonProperty("name")] public string? Name { get; set; }
    }

    public class Match
    {
        [JsonProperty("strategy")] public Strategy? Strategy { get; set; }

        [JsonProperty("teams")] public List<MatchTeam>? Teams { get; set; }

        [JsonProperty("games")] public List<Game>? Games { get; set; }
    }

    public class Game
    {
        [JsonProperty("number")] public long? Number { get; set; }

        [JsonProperty("id")] public string? Id { get; set; }

        [JsonProperty("state")] public string? State { get; set; }

        [JsonProperty("teams")] public List<GameTeam>? Teams { get; set; }

        [JsonProperty("vods")] public List<object>? Vods { get; set; }
    }

    public class GameTeam
    {
        [JsonProperty("id")] public string? Id { get; set; }

        [JsonProperty("side")] public string? Side { get; set; }
    }

    public class Strategy
    {
        [JsonProperty("count")] public long? Count { get; set; }
    }

    public class MatchTeam
    {
        [JsonProperty("id")] public string? Id { get; set; }

        [JsonProperty("name")] public string? Name { get; set; }

        [JsonProperty("code")] public string? Code { get; set; }

        [JsonProperty("image")] public Uri? Image { get; set; }

        [JsonProperty("result")] public Result? Result { get; set; }
    }

    public class Result
    {
        [JsonProperty("gameWins")] public long? GameWins { get; set; }
    }

    public class Stream
    {
        [JsonProperty("parameter")] public string? Parameter { get; set; }

        [JsonProperty("locale")] public string? Locale { get; set; }

        [JsonProperty("provider")] public string? Provider { get; set; }

        [JsonProperty("countries")] public List<string>? Countries { get; set; }

        [JsonProperty("offset")] public long? Offset { get; set; }
    }

    public class Tournament
    {
        [JsonProperty("id")] public string? Id { get; set; }
    }
}