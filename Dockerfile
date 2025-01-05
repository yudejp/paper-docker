FROM alpine:latest AS builder

ARG USERNAME=app
ARG GROUPNAME=app
ARG UID=1000
ARG GID=1000

# Install packages required to build
RUN apk add --no-cache wget

# Download server application
WORKDIR /build
RUN wget -O paper.jar https://ci.pufferfish.host/job/Pufferfish-1.21/27/artifact/build/libs/pufferfish-paperclip-1.21.3-R0.1-SNAPSHOT-mojmap.jar

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
CMD ["java", "-server", "$JAVA_OPTS", "-jar", "/bin/paper.jar"]
