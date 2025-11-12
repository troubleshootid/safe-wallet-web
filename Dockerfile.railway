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
    yarn config set httpTimeout 600000 && \
    yarn config set networkTimeout 600000

# Install dependencies and run post-install scripts
RUN yarn install && \
    yarn after-install

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Build the application (generates out/ directory for static export)
# Skip ESLint during production build (should be run in dev/CI)
RUN DISABLE_ESLINT_PLUGIN=true yarn build

# Verify build artifacts
RUN ls -la out/ && \
    echo "✅ Build successful, static files generated"

# ============================================
# Stage 2: Production Runtime Stage
# ============================================
FROM node:18-alpine AS runner

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/apps/web/out ./out
COPY --from=builder /app/apps/web/package.json ./

# Install lightweight static file server
RUN npm install -g serve@latest

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Serve static files with SPA fallback
CMD ["serve", "out", "-p", "3000", "-s"]
