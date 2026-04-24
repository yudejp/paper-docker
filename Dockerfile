FROM alpine:latest AS builder

ARG USERNAME=app
ARG GROUPNAME=app
ARG UID=1000
ARG GID=1000

# Install packages required to build
RUN apk add --no-cache wget

# Download server application
WORKDIR /build
RUN wget -O paper.jar https://fill-data.papermc.io/v1/objects/cc0948c956fa0bb1b0a399b5c8ce9c79e0a4255396fed97059e7f2ecc4e0ab12/paper-26.1.2-21.jar

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
