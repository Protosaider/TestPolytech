FROM microsoft/dotnet-framework:latest AS build-env

SHELL ["powershell"]

WORKDIR /app
COPY /app/*.csproj ./
RUN dotnet restore
COPY /app/. ./
RUN dotnet publish -c Release -o out

# # test application -- see: dotnet-docker-unit-testing.md
# FROM build-env AS testrunner
# WORKDIR /app/tests
# COPY /app/tests/. .
# ENTRYPOINT ["dotnet", "test", "--logger:trx"]

FROM microsoft/dotnet-framework:runtime AS runtime
WORKDIR /app
COPY --from=/app/build /app/out ./
ENTRYPOINT ["dotnet", "dotnetapp.dll"]

# COPY . /app
# WORKDIR /app

# RUN ["nuget.exe", "restore"]
# RUN ["C:\\Program Files (x86)\\MSBuild\\15.0\\Bin\\msbuild.exe", "ConsoleAppHelloWorld.sln"]

# ## Usage: build image, then create container and copy out the bin directory.

# CMD ["powershell"]