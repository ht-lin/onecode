# 生产环境运维手册（M0-05）

Hetzner VPS 上的生产栈与 CD 部署。对应 SPEC §9.1（加固/加密）、§10.1（拓扑）、§10.3（CI/CD）。

| 文件 | 用途 |
|---|---|
| `cloud-init.yaml` | 创建服务器时的 User data：加固 + Docker + 部署目录 |
| `compose.yaml` | 生产 Compose 栈（app / worker / db / backup 占位），CD 自动同步到 `/srv/onecode/` |
| `deploy.sh` | 服务器端部署脚本，CD 自动同步并调用 |
| `.env.example` | `/srv/onecode/.env` 模板（真实文件永不入库） |

## 1. 置备服务器（一次性，手工）

1. Hetzner Cloud 控制台 → 新建服务器：**CX22**（2 vCPU / 4GB），位置 **Falkenstein 或 Nürnberg**，镜像 **Ubuntu 24.04 LTS**，添加你的 SSH 公钥。
2. 展开 *Cloud config*，粘贴 `cloud-init.yaml`（先把其中 `ssh_authorized_keys` 的占位符换成 CD 部署专用公钥，见 §4）。
3. 开机后确认：`ssh deploy@<ip>` 可登录、密码登录被拒、`ufw status` 只放行 22/80/443、`docker compose version` 可用。

> 已知事实：Docker 发布端口走 iptables，**绕过 ufw**。本栈只发布 80/443（db/worker 无公开端口），实际暴露面与 ufw 规则一致；今后新增服务时切勿随手 `ports:` 发布内部端口。

## 2. 磁盘加密（SPEC §9.1）

Hetzner Cloud 无官方 LUKS 镜像，全盘加密需手工完成一次：

- **推荐路径（全盘 LUKS + 远程解锁）**：启动 Rescue 系统 → 用 `cryptsetup` 重装系统盘（LUKS2 + LVM），initramfs 里装 `dropbear-initramfs`，重启时通过 SSH（端口 2222）输入口令解锁。参考 Hetzner 社区教程 *"Installing Ubuntu with encrypted root on a Hetzner Cloud server"*。
- **注意**：全盘加密意味着**服务器重启后需人工 SSH 解锁一次**，解锁后 Docker 服务自启、容器 `restart: unless-stopped` 自愈。这是安全与自愈之间的既定取舍；口令存密码管理器，绝不存服务器同侧。
- **降级备选**（若暂缓全盘加密）：挂一块 Hetzner Volume 做 LUKS，把 `db_data` 卷落在其上——先满足"数据库位于加密盘"，后续再补全盘。

## 3. 域名与 DNS

- `api.<domain>` 添加 **A 记录**指向 VPS IPv4（有 IPv6 再加 AAAA）。域名未定稿前（SPEC Q1）临时域可用，换域名只需改 DNS + 服务器 `.env` 里的 `SERVER_NAME`。
- 无需手工申请证书：FrankenPHP/Caddy 检测到 `SERVER_NAME` 是真实域名后自动完成 Let's Encrypt 签发与续期（证书持久化在 `caddy_data` 卷）。

## 4. 初始化部署目录与 CD 凭据（一次性）

服务器侧：

```bash
ssh deploy@<ip>
cp /path/to/.env.example /srv/onecode/.env   # 或按 infra/.env.example 手工创建
vim /srv/onecode/.env                        # 填 SERVER_NAME、APP_SECRET、POSTGRES_PASSWORD
chmod 600 /srv/onecode/.env
```

GitHub 侧（Settings → Secrets and variables → Actions）：

| 类型 | 名称 | 内容 |
|---|---|---|
| Secret | `DEPLOY_HOST` | VPS IP 或主机名 |
| Secret | `DEPLOY_USER` | `deploy` |
| Secret | `DEPLOY_SSH_KEY` | 部署专用私钥（`ssh-keygen -t ed25519 -f deploy_key -N ''`，公钥进 cloud-init） |
| Secret | `DEPLOY_KNOWN_HOSTS` | `ssh-keyscan -H <ip>` 的输出（固定主机指纹，防中间人） |
| Variable | `API_DOMAIN` | 如 `api.example.com`（冒烟测试用；**同时是 deploy job 的总开关**——未设置时 deploy 整体跳过，服务器置备完成前 main 不会因此标红） |

GHCR 拉镜像用的是 workflow 内置的 `GITHUB_TOKEN`（`packages: read`），服务器上不留任何长期 registry 凭据，`deploy.sh` 结束即 `docker logout`。

## 5. CD 流程（自动）

merge 到 `main` 且改动命中 `api/**` 后，`.github/workflows/api.yml` 依次执行：

1. **quality** — PHPStan / cs-fixer / PHPUnit；
2. **docker** — 构建 `frankenphp_prod` 镜像（`APP_VERSION` 注入 git SHA）推 GHCR，tag：`latest` + `sha-<sha>`；
3. **deploy** — `scp` 同步 `compose.yaml`/`deploy.sh` → SSH 执行 `deploy.sh sha-<sha>`：登录 GHCR、把 tag 固化进 `.env`、`compose pull && up -d --wait`（app 容器 entrypoint 自动跑 Doctrine migrations，worker 等 app 健康后才启动）；
4. **冒烟** — runner 轮询 `https://<API_DOMAIN>/healthz`，校验返回的 `version` 等于本次 git SHA，不符则 job 标红。

## 6. Secrets 管理与轮换

`/srv/onecode/.env`（600 权限）是唯一的生产 secrets 存放点，永不入库。轮换流程：

- **`POSTGRES_PASSWORD`**：先在 db 容器里 `ALTER USER app WITH PASSWORD '<new>'`，再改 `.env`，然后 `docker compose up -d`（重建 app/worker 使新 DSN 生效）。
- **`APP_SECRET`**：改 `.env` → `docker compose up -d`。当前无依赖它的持久数据，可随时轮换。
- **部署 SSH 密钥**：新 key 加入 `deploy` 用户 `authorized_keys` → 更新 GitHub Secret → 移除旧 key。
- **泄露应急**：按上述顺序全部轮换 + Hetzner 控制台检查登录审计；数据库仅容器网络可达（无公网端口），泄露面限于应用层。

## 7. 日常运维

```bash
# 手动部署 / 回滚到任意版本（在服务器上）
echo <ghcr-token> | /srv/onecode/deploy.sh sha-<旧版本sha> <github用户名>

# 看状态 / 日志
docker compose -f /srv/onecode/compose.yaml ps
docker compose -f /srv/onecode/compose.yaml logs -f app

# 重启自愈：Docker systemd 自启 + 各服务 restart: unless-stopped，
# 全盘 LUKS 时需先 SSH:2222 解锁磁盘（见 §2）
```

备份（restic → Storage Box）与监控（Uptime Kuma / GlitchTip）在 **M2-09** 落地；`compose.yaml` 中 `backup` 服务现为占位，挂在 `backup` profile 下不随 `up -d` 启动。
