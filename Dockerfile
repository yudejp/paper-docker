FROM alpine:latest AS builder

ARG USERNAME=app
ARG GROUPNAME=app
ARG UID=1000
ARG GID=1000

# Install packages required to build
RUN apk add --no-cache wget

# Download server application
WORKDIR /build
RUN wget -O paper.jar https://fill-data.papermc.io/v1/objects/9adbd99ce7b42c9f0cb205686d83f0208a93fa6d215bb28196e12d0aaf49c2d8/paper-1.21.7-17.jar

FROM eclipse-temurin:22.0.1_8-jre-alpine AS runner

# Set timezone to Asia/Tokyo
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# Add entire papermc directory
WORKDIR /app

# Cleanup
# Copy files from builder
COPY --from=builder /build/paper.jar /bin/

# Run the server (PaperMC)
CMD java -server $JAVA_OPTS -jar /bin/paper.jar
