FROM mcr.microsoft.com/dotnet/sdk:10.0.103@sha256:89e985253248c1211e8440b82db775fd3d3c73c915ceb96766495bce050d385f AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:10.0.3@sha256:733baa8f0e8ad581482cbbe93b31d4aa3fcb91227d3ed83bdbcf3fb5c68fbc40
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
