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

FROM mcr.microsoft.com/dotnet/runtime:8.0.4@sha256:25bf7fb0be48b0f3ed6864df8adf6661ad909446dd6a207364059f31da5905d0
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
