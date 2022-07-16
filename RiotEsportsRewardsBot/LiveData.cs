// ReSharper disable once CheckNamespace

namespace RiotEsportsRewardsBot.LiveData;

public record LiveData(Data? Data);

public record Data(Schedule? Schedule);

public record Schedule(List<Event>? Events);

public record Event(string? Id, DateTimeOffset? StartTime, string? State, string? Type, string? BlockName, League? League, Match? Match, List<Stream>? Streams);

public record League(string? Id, string? Slug, string? Name, Uri? Image, long? Priority);

public record Match(string? Id, List<Team>? Teams, Strategy? Strategy);

public record Strategy(string? Type, long? Count);

public record Team(string? Id, string? Name, string? Slug, string? Code, Uri? Image, Result? Result, Record? Record);

public record Record(long? Wins, long? Losses);

public record Result(object? Outcome, long? GameWins);

public record Stream(string? Parameter, string? Locale, string? Provider, List<string>? Countries, long? Offset);
