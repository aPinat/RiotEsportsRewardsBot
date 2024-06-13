FROM mcr.microsoft.com/dotnet/sdk:8.0.302@sha256:02fdc848bbda5d57d9211a72c99bd665b421206002d66b8bc2cc0b2297c227fa AS build
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
