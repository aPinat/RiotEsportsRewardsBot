FROM mcr.microsoft.com/dotnet/sdk:10.0.401@sha256:096ca98743616ccfa14dccaa2a86615fd7345bd0c4535445226e98dbd46af2b5 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0.11@sha256:cd45a6df90f98d55605fe958a6f6a89cfb746a4dc143ca451757e3e24e4f4b50
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
