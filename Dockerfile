FROM mcr.microsoft.com/dotnet/sdk:9.0.306@sha256:a5dd7352c0c058a6f847c95a1147b060e95a532444f14b34d8fa9aaa0a76702f AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.10@sha256:1ba87a6c8246f80d6fde1e83fa0bc277200879cfdd5d68df5e40933255ac1ff3
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
