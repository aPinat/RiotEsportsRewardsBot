using Newtonsoft.Json;

namespace RiotEsportsRewardsBot.LiveData;

public class LiveData
{
    [JsonProperty("data")] public Data? Data { get; set; }
}

public class Data
{
    [JsonProperty("schedule")] public Schedule? Schedule { get; set; }
}

public class Schedule
{
    [JsonProperty("events")] public List<Event>? Events { get; set; }
}

public class Event
{
    [JsonProperty("id")] public string? Id { get; set; }

    [JsonProperty("startTime")] public DateTimeOffset? StartTime { get; set; }

    [JsonProperty("state")] public string? State { get; set; }

    [JsonProperty("type")] public string? Type { get; set; }

    [JsonProperty("blockName")] public string? BlockName { get; set; }

    [JsonProperty("league")] public League? League { get; set; }

    [JsonProperty("match")] public Match? Match { get; set; }

    [JsonProperty("streams")] public List<Stream>? Streams { get; set; }
}

public class League
{
    [JsonProperty("id")] public string? Id { get; set; }

    [JsonProperty("slug")] public string? Slug { get; set; }

    [JsonProperty("name")] public string? Name { get; set; }

    [JsonProperty("image")] public Uri? Image { get; set; }

    [JsonProperty("priority")] public long? Priority { get; set; }
}

public class Match
{
    [JsonProperty("id")] public string? Id { get; set; }

    [JsonProperty("teams")] public List<Team>? Teams { get; set; }

    [JsonProperty("strategy")] public Strategy? Strategy { get; set; }
}

public class Strategy
{
    [JsonProperty("type")] public string? Type { get; set; }

    [JsonProperty("count")] public long? Count { get; set; }
}

public class Team
{
    [JsonProperty("id")] public string? Id { get; set; }

    [JsonProperty("name")] public string? Name { get; set; }

    [JsonProperty("slug")] public string? Slug { get; set; }

    [JsonProperty("code")] public string? Code { get; set; }

    [JsonProperty("image")] public Uri? Image { get; set; }

    [JsonProperty("result")] public Result? Result { get; set; }

    [JsonProperty("record")] public Record? Record { get; set; }
}

public class Record
{
    [JsonProperty("wins")] public long? Wins { get; set; }

    [JsonProperty("losses")] public long? Losses { get; set; }
}

public class Result
{
    [JsonProperty("outcome")] public object? Outcome { get; set; }

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