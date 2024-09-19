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

FROM mcr.microsoft.com/dotnet/runtime:8.0.8@sha256:a528dc1e50ebc4152d71e4e3da8a8b52f4f238afa77f0d0f89d1b266d77f3e9b
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
