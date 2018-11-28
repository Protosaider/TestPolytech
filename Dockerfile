FROM microsoft/dotnet-framework:4.7.2 AS build-env

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

FROM microsoft/dotnet-framework:4.7.2-runtime AS runtime
WORKDIR /app
COPY --from=/app/build /app/out ./
ENTRYPOINT ["dotnet", "dotnetapp.dll"]

# COPY . /app
# WORKDIR /app

# RUN ["nuget.exe", "restore"]
# RUN ["C:\\Program Files (x86)\\MSBuild\\15.0\\Bin\\msbuild.exe", "ConsoleAppHelloWorld.sln"]

# ## Usage: build image, then create container and copy out the bin directory.

# CMD ["powershell"]

ARG TEST_VER=test_ver
ARG TEST_NS=ns_test
ARG TEST_REPO=test_repo

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_URL
ARG VERSION=0

LABEL \
# This label contains the Date/Time the image was built. The value SHOULD be formatted according to RFC 3339.
    org.label-schema.build-date=$BUILD_DATE \
#How to run a container based on the image under the Docker runtime.
    org.label-schema.docker.cmd="docker run -d -p 8080:8080 -v \"$$(pwd)/jenkins-home:/var/jenkins_home\" -v /var/run/docker.sock:/var/run/docker.sock workinghandguard/jenkins" \
#Text description of the image. May contain up to 300 characters.
    org.label-schema.description="Jenkins with docker support, Jenkins ${TEST_VER}, Docker ${DOCKER_VER}" \
#A human friendly name for the image. For example, this could be the name of a microservice in a microservice architecture.
    org.label-schema.name="workinghandguard/jenkins" \
#This label SHOULD be present to indicate the version of Label Schema in use.
    org.label-schema.schema-version="1.0" \
#URL of website with more information about the product or service provided by the container.
    org.label-schema.url="https://github.com/Protosaider/" \
#Identifier for the version of the source code from which this image was built. For example if the version control system is git this is the SHA.
    org.label-schema.vcs-ref=$VCS_REF \
#URL for the source code under version control from which this container image was built.
    org.label-schema.vcs-url="https://github.com/Protosaider/" \
#The organization that produces this image.
    org.label-schema.vendor="Fedor Ermolchev" \
#Release identifier for the contents of the image. This is entirely up to the user and could be a numeric version number like 1.2.3, or a text label.
#You SHOULD omit the version label, or use a marker like “dirty” or “test” to indicate when a container image does not match a labelled / tagged version of the code.
    org.label-schema.version="${TEST_NS}/${TEST_REPO}:${TEST_VER}-${VERSION}"