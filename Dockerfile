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

FROM mcr.microsoft.com/dotnet/runtime:10.0.12@sha256:75bd9885147aa8e7cf5e544fe3747f9cfd1e89f7530b7dbc87d3179afc07c761
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
