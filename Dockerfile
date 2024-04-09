FROM mcr.microsoft.com/dotnet/sdk:8.0.204@sha256:3add75bc2e4bc643aabe7db3eeb00d32ba120b89935e9eb49a96dca6d79d2587 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.4@sha256:2733df85f9ece0d26fbf7e3f2e2894f91e9c322caf628da96dda1cd131f74d41
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
