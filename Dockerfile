# ============================================
# Production Dockerfile for Xone Network
# Pre-configured for immediate deployment
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

# Set environment variables - All hardcoded for Xone Network
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS="--max-old-space-size=6144"

# Core Xone Network Configuration
ENV NEXT_PUBLIC_BRAND_NAME=Xone
ENV NEXT_PUBLIC_IS_OFFICIAL_HOST=false
ENV NEXT_PUBLIC_IS_PRODUCTION=true
ENV NEXT_PUBLIC_DEFAULT_MAINNET_CHAIN_ID=3721

# Gateway URLs
ENV NEXT_PUBLIC_GATEWAY_URL_PRODUCTION=https://safe-client.xone.org
ENV NEXT_PUBLIC_GATEWAY_URL_STAGING=https://safe-client.xone.org

# WalletConnect
ENV NEXT_PUBLIC_WC_PROJECT_ID=5ad37922941a8ac1add3e3eff189c8ca

# Analytics & Tracking (Disabled for Xone)
ENV NEXT_PUBLIC_PROD_MIXPANEL_TOKEN=00000000000000000000000000000000
ENV NEXT_PUBLIC_STAGING_MIXPANEL_TOKEN=00000000000000000000000000000000
ENV NEXT_PUBLIC_PROD_GA_TRACKING_ID=
ENV NEXT_PUBLIC_SAFE_APPS_GA_TRACKING_ID=
ENV NEXT_PUBLIC_TEST_GA_TRACKING_ID=

# Firebase Push Notifications (Disabled)
ENV NEXT_PUBLIC_FIREBASE_OPTIONS_PRODUCTION=
ENV NEXT_PUBLIC_FIREBASE_OPTIONS_STAGING=
ENV NEXT_PUBLIC_FIREBASE_VAPID_KEY_PRODUCTION=
ENV NEXT_PUBLIC_FIREBASE_VAPID_KEY_STAGING=

# Third-party Services (Disabled)
ENV NEXT_PUBLIC_INFURA_TOKEN=
ENV NEXT_PUBLIC_SAFE_APPS_INFURA_TOKEN=
ENV NEXT_PUBLIC_BEAMER_ID=
ENV NEXT_PUBLIC_BLOCKAID_CLIENT_ID=
ENV NEXT_PUBLIC_DATADOG_CLIENT_TOKEN=
ENV NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID=

# Tenderly Simulation (Disabled)
ENV NEXT_PUBLIC_TENDERLY_ORG_NAME=
ENV NEXT_PUBLIC_TENDERLY_PROJECT_NAME=
ENV NEXT_PUBLIC_TENDERLY_SIMULATE_ENDPOINT_URL=

# Error Tracking (Disabled)
ENV NEXT_PUBLIC_SENTRY_DSN=

# Build Configuration
ENV DISABLE_ESLINT_PLUGIN=true

# Get git commit hash and build the application
RUN COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "production-build") && \
    NEXT_PUBLIC_COMMIT_HASH=$COMMIT_HASH yarn build

# Verify build artifacts
RUN ls -la out/ && echo "Xone Network build completed successfully"

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

# Set runtime environment
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# Serve static files with SPA fallback
CMD ["serve", "out", "-p", "3000", "-s"]
