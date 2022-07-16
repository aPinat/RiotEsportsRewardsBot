using System.Net.Http.Json;
using System.Text.Json.Nodes;
using RiotEsportsRewardsBot.EventDetailsData;
using RiotEsportsRewardsBot.LiveData;

var riotXApiKey = Environment.GetEnvironmentVariable("RIOT_X_API_KEY") ?? throw new ApplicationException("RIOT_X_API_KEY missing.");
var riotAccessToken = Environment.GetEnvironmentVariable("RIOT_ACCESS_TOKEN") ?? throw new ApplicationException("RIOT_ACCESS_TOKEN missing.");

var esports = new HttpClient();
esports.DefaultRequestHeaders.TryAddWithoutValidation("x-api-key", riotXApiKey);

var rewards = new HttpClient();

while (true)
{
    try
    {
        var livedata = await esports.GetFromJsonAsync<LiveData>("https://esports-api.lolesports.com/persisted/gw/getLive?hl=en-GB");
        if (livedata?.Data?.Schedule?.Events == null)
            goto END;

        foreach (var @event in livedata.Data.Schedule.Events)
        {
            Console.WriteLine($"Found Event: {@event.League?.Name} at {DateTime.Now:s}");
            switch (@event.Type)
            {
                case "match":
                    Console.WriteLine(
                        $"Currently broadcasting {@event.League?.Name} Match: {@event.BlockName} - {@event.Match?.Teams?[0].Name} ({@event.Match?.Teams?[0].Code}) vs. {@event.Match?.Teams?[1].Name} ({@event.Match?.Teams?[1].Code})");
                    break;
                case "show":
                    Console.WriteLine($"Currently broadcasting {@event.League?.Name} Show");
                    break;
                default:
                    Console.WriteLine($"Currently broadcasting {@event.League?.Name} {@event.Type}");
                    break;
            }

            var eventData = await esports.GetFromJsonAsync<EventDetailsData>($"https://esports-api.lolesports.com/persisted/gw/getEventDetails?hl=en-GB&id={@event.Id}");

            var stream = eventData?.Data?.Event?.Streams?.FirstOrDefault(s => s.Locale != null && s.Locale.StartsWith("en")) ?? eventData?.Data?.Event?.Streams?.FirstOrDefault();
            if (stream == null)
            {
                Console.WriteLine("No Stream found!");
                Console.WriteLine(eventData);
                Console.WriteLine();
                continue;
            }

            if (eventData?.Data?.Event?.Tournament?.Id == null)
            {
                Console.WriteLine("Cannot find Tournament ID!");
                Console.WriteLine(eventData);
                Console.WriteLine();
                continue;
            }

            var body = JsonContent.Create(new
            {
                stream_id = stream.Parameter,
                source = stream.Provider,
                stream_position_time = $"{DateTime.UtcNow:O}",
                geolocation = new { code = "DE", area = "EU" },
                tournament_id = eventData.Data.Event.Tournament.Id
            });
            Console.WriteLine($"Sending: {await body.ReadAsStringAsync()}");

            // CloudFlare does not like this sometimes...
            // await Task.WhenAll(riotAccessToken.Split(';').Select(token => Task.Run(async () =>
            // {
            //     var responseMessage = await rewards.SendAsync(new HttpRequestMessage(HttpMethod.Post, "https://rex.rewards.lolesports.com/v1/events/watch")
            //     {
            //         Content = body, Headers = { { "Authorization", $"Bearer {token}" } }
            //     });
            //     var response = await responseMessage.Content.ReadAsStringAsync();
            //     Console.WriteLine($"Received: {response.Replace("\n", "")}");
            // })));

            foreach (var token in riotAccessToken.Split(';'))
            {
                var responseMessage = await rewards.SendAsync(new HttpRequestMessage(HttpMethod.Post, "https://rex.rewards.lolesports.com/v1/events/watch")
                {
                    Content = body, Headers = { { "Authorization", $"Bearer {token}" } }
                });
                var response = await responseMessage.Content.ReadFromJsonAsync<JsonObject>();
                Console.WriteLine($"Received: {response?.ToJsonString()}");
            }

            Console.WriteLine();
        }
    }
    catch (Exception e)
    {
        Console.WriteLine(e);
    }

END:
    await Task.Delay(TimeSpan.FromMinutes(1));
}
