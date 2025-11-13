# ============================================
# Optimized Dockerfile for Railway Deployment
# Repository: troubleshootid/safe-wallet-web
# ============================================

# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    libc6-compat \
    git \
    python3 \
    py3-pip \
    make \
    g++ \
    libusb-dev \
    eudev-dev \
    linux-headers

WORKDIR /app

# Copy project files
COPY . .

# Switch to web app directory
WORKDIR /app/apps/web

# Enable Corepack and configure Yarn
RUN corepack enable && \
    yarn config set httpTimeout 600000

# Install dependencies and run post-install scripts
RUN yarn install && \
    yarn after-install

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Copy startup script that will build at runtime
COPY apps/web/docker-entrypoint.sh /app/apps/web/
RUN chmod +x /app/apps/web/docker-entrypoint.sh

# ============================================
# Stage 2: Production Runtime Stage
# ============================================
FROM node:18-alpine AS runner

# Install system dependencies needed for runtime
RUN apk add --no-cache git

WORKDIR /app

# Enable Corepack to use Yarn 4.5.3 specified in package.json
RUN corepack enable

# Copy entire build context from builder
# This includes source code, node_modules, and the startup script
COPY --from=builder /app ./

WORKDIR /app/apps/web

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=10000

# Expose port
EXPOSE 10000

# Use startup script as entrypoint
# The script will build Next.js at runtime when environment variables are available
ENTRYPOINT ["/app/apps/web/docker-entrypoint.sh"]
