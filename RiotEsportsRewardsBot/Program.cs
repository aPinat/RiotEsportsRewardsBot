using System;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace RiotEsportsRewardsBot
{
    internal static class Program
    {
        private static async Task Main()
        {
            var riotXApiKey = Environment.GetEnvironmentVariable("RIOT_X_API_KEY") ?? throw new ApplicationException("RIOT_X_API_KEY missing.");
            var riotAccessToken = Environment.GetEnvironmentVariable("RIOT_ACCESS_TOKEN") ?? throw new ApplicationException("RIOT_ACCESS_TOKEN missing.");

            while (true)
            {
                try
                {
                    var http = new HttpClient();
                    var responseMessage = await http.SendAsync(
                        new HttpRequestMessage(HttpMethod.Get, "https://esports-api.lolesports.com/persisted/gw/getLive?hl=en-GB")
                            { Headers = { { "x-api-key", riotXApiKey } } });
                    var live = await responseMessage.Content.ReadAsStringAsync();
                    var livedata = JsonConvert.DeserializeObject<LiveData.LiveData>(live);
                    if (livedata?.Data?.Schedule?.Events == null)
                    {
                        await Task.Delay(TimeSpan.FromMinutes(1));
                        continue;
                    }

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

                        responseMessage = await http.SendAsync(
                            new HttpRequestMessage(HttpMethod.Get, $"https://esports-api.lolesports.com/persisted/gw/getEventDetails?hl=en-GB&id={@event.Id}")
                                { Headers = { { "x-api-key", riotXApiKey } } });
                        var eventDataString = await responseMessage.Content.ReadAsStringAsync();
                        var eventData = JsonConvert.DeserializeObject<EventDetailsData.EventDetailsData>(eventDataString);

                        var stream = eventData?.Data?.Event?.Streams?.FirstOrDefault(s => s.Locale != null && s.Locale.StartsWith("en")) ?? eventData?.Data?.Event?.Streams?.FirstOrDefault();
                        if (stream == null)
                        {
                            Console.WriteLine("No Stream found!");
                            Console.WriteLine(eventDataString);
                            continue;
                        }

                        if (eventData?.Data?.Event?.Tournament?.Id == null)
                        {
                            Console.WriteLine("Cannot find Tournement ID!");
                            Console.WriteLine(eventDataString);
                            continue;
                        }

                        var body =
                            $"{{\"stream_id\":\"{stream.Parameter}\",\"source\":\"{stream.Provider}\",\"stream_position_time\":\"{DateTime.UtcNow:O}\",\"geolocation\":{{\"code\":\"DE\",\"area\":\"EU\"}},\"tournament_id\":\"{eventData.Data.Event.Tournament.Id}\"}}";
                        Console.WriteLine($"Sending: {body}");
                        responseMessage = await http.SendAsync(new HttpRequestMessage(HttpMethod.Post, "https://rex.rewards.lolesports.com/v1/events/watch")
                        {
                            Content = new StringContent(body, Encoding.UTF8, "application/json"),
                            Headers =
                            {
                                {
                                    "Authorization",
                                    $"Bearer {riotAccessToken}"
                                }
                            }
                        });
                        var rewards = await responseMessage.Content.ReadAsStringAsync();
                        Console.WriteLine($"Received: {rewards.Replace("\n", "")}");
                        Console.WriteLine();
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e);
                }

                await Task.Delay(TimeSpan.FromMinutes(1));
            }
        }
    }
}