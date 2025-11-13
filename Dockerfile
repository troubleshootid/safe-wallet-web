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

# Hard-code environment variables for Xone Network
# Since Render doesn't pass env vars to Docker build, we set them here
ENV NEXT_PUBLIC_BRAND_NAME=Xone
ENV NEXT_PUBLIC_IS_OFFICIAL_HOST=false
ENV NEXT_PUBLIC_DEFAULT_MAINNET_CHAIN_ID=3721
ENV NEXT_PUBLIC_GATEWAY_URL_PRODUCTION=https://safe-client-gateway.onrender.com
ENV NEXT_PUBLIC_WC_PROJECT_ID=5ad37922941a8ac1add3e3eff189c8ca
ENV NEXT_PUBLIC_PROD_MIXPANEL_TOKEN=00000000000000000000000000000000
ENV NEXT_PUBLIC_STAGING_MIXPANEL_TOKEN=00000000000000000000000000000000
ENV DISABLE_ESLINT_PLUGIN=true

# Get git commit hash and build the application
RUN COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "docker-build") && \
    echo "Building with NEXT_PUBLIC_BRAND_NAME=$NEXT_PUBLIC_BRAND_NAME" && \
    NEXT_PUBLIC_COMMIT_HASH=$COMMIT_HASH yarn build

# Verify build artifacts
RUN ls -la out/ && echo "✅ Build completed with brand name: $NEXT_PUBLIC_BRAND_NAME"

# ============================================
# Stage 2: Production Runtime Stage
# ============================================
FROM node:18-alpine AS runner

WORKDIR /app

# Copy only the built static files
COPY --from=builder /app/apps/web/out ./out
COPY --from=builder /app/apps/web/package.json ./

# Install lightweight static file server
RUN npm install -g serve@latest

# Set environment variables
ENV NODE_ENV=production
ENV PORT=10000

# Expose port
EXPOSE 10000

# Serve static files with SPA fallback
CMD ["serve", "out", "-p", "10000", "-s"]
