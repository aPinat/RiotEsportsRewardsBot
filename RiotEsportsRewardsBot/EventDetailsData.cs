// ReSharper disable once CheckNamespace

namespace RiotEsportsRewardsBot.EventDetailsData;

public record EventDetailsData(Data? Data);

public record Data(Event? Event);

public record Event(string? Id, string? Type, Tournament? Tournament, League? League, Match? Match, List<Stream>? Streams);

public record League(string? Id, string? Slug, Uri? Image, string? Name);

public record Match(Strategy? Strategy, List<MatchTeam>? Teams, List<Game>? Games);

public record Game(long? Number, string? Id, string? State, List<GameTeam>? Teams, List<object>? Vods);

public record GameTeam(string? Id, string? Side);

public record Strategy(long? Count);

public record MatchTeam(string? Id, string? Name, string? Code, Uri? Image, Result? Result);

public record Result(long? GameWins);

public record Stream(string? Parameter, string? Locale, string? Provider, List<string>? Countries, long? Offset);

public record Tournament(string? Id);
