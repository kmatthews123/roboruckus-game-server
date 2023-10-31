FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
RUN git clone https://github.com/RoboRuckus/roboruckus-game-server.git
WORKDIR /app/roboruckus-game-server/src/RoboRuckus
RUN dotnet build "RoboRuckus.csproj" -v m -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/sdk:7.0
COPY --from=build /app/build/GameConfig/Boards /default/boards
COPY --from=build /app/build/wwwroot/images/boards /default/images
COPY --from=build /app/build /app
COPY startup.sh /app
ENV ASPNETCORE_URLS=http://*:8082

CMD ["./startup.sh"]