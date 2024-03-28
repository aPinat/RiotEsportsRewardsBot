FROM mcr.microsoft.com/dotnet/sdk:8.0.203@sha256:249a78aa4ce22ab872d0dff0490a6389e7bc087d2c080c4ffc7569b49cf0e23b AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.3@sha256:0eea5cbf81e777f83bc15a7df0348adb8e06ee229260bedbbbc8a6011ab67581
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
