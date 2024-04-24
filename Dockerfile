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

FROM mcr.microsoft.com/dotnet/runtime:8.0.4@sha256:311428ed4571680aee6067c43ee5d0e45a15eb0b2e599fe30ea07d7de4ecc53c
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
