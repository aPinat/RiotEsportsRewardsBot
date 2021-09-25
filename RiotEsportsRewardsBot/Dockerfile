FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore "RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj"
COPY . .
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build "RiotEsportsRewardsBot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RiotEsportsRewardsBot.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
