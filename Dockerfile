FROM mcr.microsoft.com/dotnet/sdk:8.0.300@sha256:935902ef9eee58a9226b906e3d6ff1b2abaca240c9d5b4ac8dca9943b26c8f33 AS build
WORKDIR /src

COPY ["*.sln", "."]
COPY ["RiotEsportsRewardsBot/RiotEsportsRewardsBot.csproj", "RiotEsportsRewardsBot/"]
RUN dotnet restore

COPY ["RiotEsportsRewardsBot/", "RiotEsportsRewardsBot/"]
WORKDIR "/src/RiotEsportsRewardsBot"
RUN dotnet build -c Release --no-restore

FROM build AS publish
RUN dotnet publish -c Release --no-build -o /app

FROM mcr.microsoft.com/dotnet/runtime:8.0.6@sha256:fcd1efab7bccbbdf5b66fa89bf1301b1bf28ec763f47c1b0ea9b060667d5b452
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "RiotEsportsRewardsBot.dll"]
