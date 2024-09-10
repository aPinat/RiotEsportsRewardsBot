FROM mcr.microsoft.com/dotnet/sdk:8.0.401-1@sha256:a364676fedc145cf88caad4bfb3cc372aae41e596c54e8a63900a2a1c8e364c6 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.8@sha256:b8c196c7e3e87685846c072955ee5cc6354ca851d9ca2a942bf05318e8e6b19a
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
