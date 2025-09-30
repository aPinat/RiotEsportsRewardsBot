FROM mcr.microsoft.com/dotnet/sdk:9.0.305@sha256:123b43e4d9775451d8ed63af324a42132707b4edb14770bcdf5c85cf55bc45f1 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.9@sha256:5040af5025cf2e12b1c4eb04c033342c39fe654bbd9395d24cc2635ec196c7f4
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
