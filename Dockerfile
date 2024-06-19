FROM mcr.microsoft.com/dotnet/sdk:8.0.302-1@sha256:3189e564f19e016a43838a46609fc81349f07322fdf6bc3299bd13f0dca9e647 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.6@sha256:47e0bc724479c8e4cf7b164b57e87da8a02f22a8e236b9b5b469d1ffd20fbe84
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
