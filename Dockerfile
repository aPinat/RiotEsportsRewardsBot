FROM mcr.microsoft.com/dotnet/sdk:8.0.203@sha256:9bb0d97c4361cc844f225c144ac2adb2b65fabfef21f95caedcf215d844238fe AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.3@sha256:c9804086710f1325e63cf2ed3f83deb10a3a5d07cc0e762b3bb27f0d8b7d6a7b
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
