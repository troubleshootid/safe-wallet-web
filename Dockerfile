# ============================================
# Flexible Dockerfile for Safe Wallet Web
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

# Define build arguments with default values
# These can be overridden during docker build with --build-arg
ARG NEXT_PUBLIC_BRAND_NAME=""
ARG NEXT_PUBLIC_IS_OFFICIAL_HOST="true"
ARG NEXT_PUBLIC_IS_PRODUCTION="false"
ARG NEXT_PUBLIC_DEFAULT_MAINNET_CHAIN_ID=""
ARG NEXT_PUBLIC_GATEWAY_URL_PRODUCTION=""
ARG NEXT_PUBLIC_GATEWAY_URL_STAGING=""
ARG NEXT_PUBLIC_WC_PROJECT_ID=""
ARG NEXT_PUBLIC_PROD_MIXPANEL_TOKEN=""
ARG NEXT_PUBLIC_STAGING_MIXPANEL_TOKEN=""
ARG NEXT_PUBLIC_BEAMER_ID=""
ARG NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID=""
ARG NEXT_PUBLIC_INFURA_TOKEN=""
ARG NEXT_PUBLIC_SAFE_APPS_INFURA_TOKEN=""
ARG NEXT_PUBLIC_SENTRY_DSN=""
ARG NEXT_PUBLIC_TENDERLY_ORG_NAME=""
ARG NEXT_PUBLIC_TENDERLY_PROJECT_NAME=""
ARG NEXT_PUBLIC_TENDERLY_SIMULATE_ENDPOINT_URL=""
ARG DISABLE_ESLINT_PLUGIN="false"
ARG APP_PORT="3000"

# Set environment variables from build arguments
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NEXT_PUBLIC_BRAND_NAME=${NEXT_PUBLIC_BRAND_NAME}
ENV NEXT_PUBLIC_IS_OFFICIAL_HOST=${NEXT_PUBLIC_IS_OFFICIAL_HOST}
ENV NEXT_PUBLIC_IS_PRODUCTION=${NEXT_PUBLIC_IS_PRODUCTION}
ENV NEXT_PUBLIC_DEFAULT_MAINNET_CHAIN_ID=${NEXT_PUBLIC_DEFAULT_MAINNET_CHAIN_ID}
ENV NEXT_PUBLIC_GATEWAY_URL_PRODUCTION=${NEXT_PUBLIC_GATEWAY_URL_PRODUCTION}
ENV NEXT_PUBLIC_GATEWAY_URL_STAGING=${NEXT_PUBLIC_GATEWAY_URL_STAGING}
ENV NEXT_PUBLIC_WC_PROJECT_ID=${NEXT_PUBLIC_WC_PROJECT_ID}
ENV NEXT_PUBLIC_PROD_MIXPANEL_TOKEN=${NEXT_PUBLIC_PROD_MIXPANEL_TOKEN}
ENV NEXT_PUBLIC_STAGING_MIXPANEL_TOKEN=${NEXT_PUBLIC_STAGING_MIXPANEL_TOKEN}
ENV NEXT_PUBLIC_BEAMER_ID=${NEXT_PUBLIC_BEAMER_ID}
ENV NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID=${NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID}
ENV NEXT_PUBLIC_INFURA_TOKEN=${NEXT_PUBLIC_INFURA_TOKEN}
ENV NEXT_PUBLIC_SAFE_APPS_INFURA_TOKEN=${NEXT_PUBLIC_SAFE_APPS_INFURA_TOKEN}
ENV NEXT_PUBLIC_SENTRY_DSN=${NEXT_PUBLIC_SENTRY_DSN}
ENV NEXT_PUBLIC_TENDERLY_ORG_NAME=${NEXT_PUBLIC_TENDERLY_ORG_NAME}
ENV NEXT_PUBLIC_TENDERLY_PROJECT_NAME=${NEXT_PUBLIC_TENDERLY_PROJECT_NAME}
ENV NEXT_PUBLIC_TENDERLY_SIMULATE_ENDPOINT_URL=${NEXT_PUBLIC_TENDERLY_SIMULATE_ENDPOINT_URL}
ENV DISABLE_ESLINT_PLUGIN=${DISABLE_ESLINT_PLUGIN}

# Get git commit hash and build the application
RUN COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "docker-build") && \
    NEXT_PUBLIC_COMMIT_HASH=$COMMIT_HASH yarn build

# Verify build artifacts
RUN ls -la out/ && echo "✅ Build completed successfully"

# ============================================
# Stage 2: Production Runtime Stage
# ============================================
FROM node:18-alpine AS runner

WORKDIR /app

# Accept port as build argument for runtime stage
ARG APP_PORT="3000"

# Copy only the built static files
COPY --from=builder /app/apps/web/out ./out
COPY --from=builder /app/apps/web/package.json ./

# Install lightweight static file server
RUN npm install -g serve@latest

# Set environment variables
ENV NODE_ENV=production
ENV PORT=${APP_PORT}

# Expose port (can be overridden)
EXPOSE ${APP_PORT}

# Serve static files with SPA fallback
CMD serve out -p ${PORT} -s
