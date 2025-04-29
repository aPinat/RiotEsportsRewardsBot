FROM mcr.microsoft.com/dotnet/sdk:9.0.203@sha256:fe3c1ed472bb0964c100f06aa9b1759f5ed84e0dfe6904d60f6a82159d3c7ae4 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.4@sha256:9d42d7d4d892e2afc571884e9b67f3b1ebb361166ee14151fc6d1bd539cbfeb3
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
