FROM mcr.microsoft.com/dotnet/sdk:8.0.303@sha256:7d0ba26469267b563120456557e38eccef9972cb6b9cfbbd47a50d1218fa7b30 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.7@sha256:94aa90156b2962aa8e42f3444e0d6569f90d925ee997c99ac0be2876e2a2c764
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
