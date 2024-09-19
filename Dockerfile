FROM mcr.microsoft.com/dotnet/sdk:8.0.401-1@sha256:1e8c6666f3e31f96d22a5c77054589f85078a4850595421c6999395f26e79b9a AS build
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
