FROM mcr.microsoft.com/dotnet/sdk:9.0.301@sha256:e9cbcba902d7ac6afb055c4defb4e1e03d62110fd009ba4dd4ad4b5c029e8c8e AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.6@sha256:9563e814250fef5dde24cd68916878ef5faa8f993bf99a06db1c947f23217996
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
