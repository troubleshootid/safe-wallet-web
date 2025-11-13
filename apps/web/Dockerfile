FROM node:18-alpine
RUN apk add --no-cache libc6-compat git python3 py3-pip make g++ libusb-dev eudev-dev linux-headers

# Set working directory
WORKDIR /app

# Copy root
COPY . .

# Set working directory to the web app
WORKDIR apps/web

# Enable corepack and configure yarn
RUN corepack enable
RUN yarn config set httpTimeout 300000

# Run any custom post-install scripts
RUN yarn install --immutable
RUN yarn after-install

# Copy startup script
COPY docker-entrypoint.sh /app/apps/web/
RUN chmod +x /app/apps/web/docker-entrypoint.sh

# Fixed environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=10000

# Expose the port
EXPOSE 10000

# Use startup script as entrypoint
# Environment variables will be available at runtime for Next.js build
ENTRYPOINT ["/app/apps/web/docker-entrypoint.sh"]
