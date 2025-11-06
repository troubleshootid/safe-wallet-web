# Cloudflare Pages Deployment Guide

This document explains how to deploy the Safe Wallet Web application to Cloudflare Pages with automatic deployment.

## Prerequisites

- GitHub account
- Cloudflare account
- Code pushed to GitHub repository

## Deployment Steps

### 1. Login to Cloudflare Dashboard

Visit https://dash.cloudflare.com/ and sign in

### 2. Create a New Pages Project

1. Click **Workers & Pages** in the left navigation
2. Click **Create application** button
3. Select the **Pages** tab
4. Click **Connect to Git**

### 3. Connect GitHub Repository

1. Select your GitHub account and authorize
2. Select repository: `safe-wallet-web`
3. Select branch: `test` (or your preferred branch)

### 4. Configure Build Settings

Fill in the following information on the build configuration page:

**Framework preset:** `None` (manual configuration)

**Build command:**
```bash
./build-cf.sh
```

**Build output directory:**
```
apps/web/.next
```

**Root directory (advanced):**
```
/
```

### 5. Environment Variables Configuration

Click **Environment variables** and add the following:

| Variable | Value | Description |
|----------|-------|-------------|
| `NODE_VERSION` | `18` | Node.js version |
| `YARN_VERSION` | `4.6.0` | Yarn version |
| `NODE_ENV` | `production` | Environment type |

Add any additional environment variables as needed.

### 6. Advanced Build Settings

Expand **Advanced** settings:

**Node.js version:** `18`

**Install Command (optional):**
```bash
yarn install --immutable
```

### 7. Start Deployment

Click **Save and Deploy** to begin the first deployment.

## Automatic Deployment

Once configured, Cloudflare Pages will automatically:

1. Detect code changes
2. Pull the latest code
3. Execute build command
4. Deploy new version
5. Provide preview URL

Every push to the configured branch will trigger a new deployment.

## Access the Deployed Application

After deployment completes, you will receive:

- **Production URL**: `https://your-project-name.pages.dev`
- **Preview URLs**: Each commit generates a unique preview link

## Monitor Deployment Status

In the Cloudflare Dashboard Pages project page, you can:

- View deployment history
- View build logs
- Rollback to previous versions
- Manage custom domains

## Custom Domain (Optional)

1. Click **Custom domains** in project settings
2. Add your domain
3. Configure DNS records as instructed

## Troubleshooting

### Build Failures

Check the build logs for error messages:
- Dependency installation issues
- Missing environment variables
- Build script errors

### Runtime Errors

- Verify environment variables are correctly configured
- Check browser console for error messages
- Review Cloudflare Pages function logs

## Optimization Tips

1. **Cache Optimization**: Cloudflare Pages automatically handles static asset caching
2. **Edge Rendering**: Leverage Cloudflare's global CDN network
3. **Build Cache**: Enable dependency caching to speed up builds

## Cost

Cloudflare Pages free tier includes:
- Unlimited static requests
- Unlimited bandwidth
- 500 builds/month
- 20,000 function invocations/day

Sufficient for personal projects and small to medium applications.

## Support

For issues, please refer to:
- [Cloudflare Pages Documentation](https://developers.cloudflare.com/pages/)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)
