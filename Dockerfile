FROM mcr.microsoft.com/dotnet/sdk:9.0.201@sha256:4845ef954a33b55c1a1f5db1ac24ba6cedb1dafb7f0b6a64ebce2fabe611f0c0 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.3@sha256:03fe3b9f932fc9c3d1a76c6a0fecc8e2f1b9ed302deda29f920d81e50c9aad6f
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
