# Cloudflare Pages 部署指南

本文档说明如何将 Safe Wallet Web 应用部署到 Cloudflare Pages,并实现自动部署。

## 前提条件

- GitHub 账号
- Cloudflare 账号
- 代码已推送到 GitHub 仓库

## 部署步骤

### 1. 登录 Cloudflare Dashboard

访问 https://dash.cloudflare.com/ 并登录

### 2. 创建新的 Pages 项目

1. 点击左侧导航栏的 **Workers & Pages**
2. 点击 **Create application** 按钮
3. 选择 **Pages** 标签
4. 点击 **Connect to Git**

### 3. 连接 GitHub 仓库

1. 选择你的 GitHub 账号并授权
2. 选择仓库: `troubleshootid/safe-wallet-web`
3. 选择分支: `test` (或你想部署的分支)

### 4. 配置构建设置

在构建配置页面填写以下信息:

**Framework preset:** `None` (手动配置)

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

### 5. 环境变量配置

点击 **Environment variables** 添加以下变量:

| 变量名 | 值 | 说明 |
|--------|-------|------|
| `NODE_VERSION` | `18` | Node.js 版本 |
| `YARN_VERSION` | `4.6.0` | Yarn 版本 |
| `NODE_ENV` | `production` | 环境类型 |

如果有其他环境变量需求,继续添加即可。

### 6. 高级构建设置

展开 **Advanced** 设置:

**Node.js version:** `18`

**Install Command (可选):**
```bash
yarn install --immutable
```

### 7. 开始部署

点击 **Save and Deploy** 按钮开始首次部署。

## 自动部署

配置完成后,每次向 `test` 分支推送代码时,Cloudflare Pages 会自动:

1. 检测到代码变更
2. 拉取最新代码
3. 执行构建命令
4. 部署新版本
5. 提供预览 URL

## 访问部署的应用

部署完成后,你会获得:

- **生产环境 URL**: `https://your-project-name.pages.dev`
- **预览 URL**: 每次提交会生成唯一的预览链接

## 监控部署状态

在 Cloudflare Dashboard 的 Pages 项目页面,你可以:

- 查看部署历史
- 查看构建日志
- 回滚到之前的版本
- 管理自定义域名

## 自定义域名(可选)

1. 在项目设置中点击 **Custom domains**
2. 添加你的域名
3. 按照提示配置 DNS 记录

## 故障排查

### 构建失败

检查构建日志中的错误信息:
- 依赖安装问题
- 环境变量缺失
- 构建脚本错误

### 运行时错误

- 检查环境变量是否正确配置
- 查看浏览器控制台的错误信息
- 检查 Cloudflare Pages 函数日志

## 优化建议

1. **缓存优化**: Cloudflare Pages 自动处理静态资源缓存
2. **边缘渲染**: 利用 Cloudflare 的全球 CDN 网络
3. **构建缓存**: 启用依赖缓存加速构建

## 成本

Cloudflare Pages 免费套餐包括:
- 无限静态请求
- 无限带宽
- 500 次构建/月
- 20,000 次函数调用/天

对于个人项目和中小型应用完全足够使用。

## 支持

如有问题,请查看:
- [Cloudflare Pages 文档](https://developers.cloudflare.com/pages/)
- [Next.js 部署指南](https://nextjs.org/docs/deployment)
