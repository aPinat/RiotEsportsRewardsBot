FROM mcr.microsoft.com/dotnet/sdk:9.0.303@sha256:670ef9e8eca44c8baa0bd1c229ccde9537064260ef14d54738b7a87916609312 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:9.0.7@sha256:c4093cabaece5ace4a1c8fd240fa821b99a91c477c7b7dfe1dbf4678d09c57c4
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
