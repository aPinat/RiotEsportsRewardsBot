FROM mcr.microsoft.com/dotnet/sdk:11.0.100@sha256:2794448a07118a6eaf00f29ab5d2bf44928517ce5ff86505a63a69230374f599 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:11.0.0@sha256:43a34aaf5edd4ae1a36dd82fe857602e4b5449bfcf1a9bed753eeb0727dc0c70
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
