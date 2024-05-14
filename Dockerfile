FROM mcr.microsoft.com/dotnet/sdk:8.0.204@sha256:03476e8b974ca8e5084bf63742d85f04a5f53df0ae37c82d31bae228eb297e6c AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.5@sha256:af08db0ca73b3e113ddbee56d0a3414896023f78ef0ff6eb454b85a2ddc7e2f8
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
