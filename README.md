# IPTV Fetcher

自动从 GitHub 获取 IPTV 直播源 M3U 文件。

## Docker 镜像

```bash
# 拉取镜像
docker pull ghcr.io/yao1987825/iptv-fetcher:latest

# 启动容器
docker run -d \
  --name iptv_fetcher \
  --network host \
  -v ./data:/data \
  -e SOURCE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/yaojiwei520/IPTV/refs/heads/main/iptv.m3u" \
  ghcr.io/yao1987825/iptv-fetcher:latest
```

## 功能

- 自动从指定的 GitHub 仓库获取 IPTV 直播源
- 支持自定义获取间隔
- 原子写入（先下载到临时文件再重命名）
- 支持代理配置

## 快速开始

### 1. 启动服务

```bash
# 创建数据目录
mkdir -p ./data

# 启动容器
docker run -d \
  --name iptv_fetcher \
  --network host \
  -v ./data:/data \
  -e SOURCE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/yaojiwei520/IPTV/refs/heads/main/iptv.m3u" \
  -e FETCH_INTERVAL=3600 \
  curlimages/curl:latest \
  sh -c 'while true; do curl -fsSL "$SOURCE_URL" -o /data/iptv.m3u.tmp && mv /data/iptv.m3u.tmp /data/iptv.m3u && echo "$(date -Iseconds) updated"; sleep $FETCH_INTERVAL; done'
```

### 2. 使用 Docker Compose

```yaml
version: '3.8'

services:
  iptv_fetcher:
    image: curlimages/curl:latest
    container_name: iptv_fetcher
    network_mode: host
    volumes:
      - ./data:/data
    environment:
      - SOURCE_URL=https://gh-proxy.com/https://raw.githubusercontent.com/yaojiwei520/IPTV/refs/heads/main/iptv.m3u
      - FETCH_INTERVAL=3600
    restart: unless-stopped
```

## 配置说明

### 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| SOURCE_URL | - | M3U 文件的 URL（必填） |
| FETCH_INTERVAL | 3600 | 获取间隔（秒），默认 1 小时 |
| OUTPUT_FILE | /data/iptv.m3u | 输出文件路径 |
| PROXY | - | 代理地址（如需） |

## 使用示例

### 使用 GitHub 代理

```bash
# 国内服务器使用代理
-e SOURCE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/xxx/xxx/main/iptv.m3u"
```

### 自定义获取间隔

```bash
# 每 30 分钟获取一次
-e FETCH_INTERVAL=1800
```

### 查看日志

```bash
docker logs -f iptv_fetcher
```

## 常用直播源

```bash
# fanmingming/live
-e SOURCE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/fanmingming/live/main/tv/m3u/index.m3u"

# yaojiwei520/IPTV
-e SOURCE_URL="https://gh-proxy.com/https://raw.githubusercontent.com/yaojiwei520/IPTV/refs/heads/main/iptv.m3u"
```

## 目录结构

```
.
├── docker-compose.yml    # Docker Compose 配置
├── README.md            # 本文档
└── data/                # 数据目录（自动创建）
    └── iptv.m3u         # 获取的直播源文件
```
