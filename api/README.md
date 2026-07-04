# OneCode API

Symfony 7.4 + API Platform 4 + PostgreSQL 16 后端，运行在 FrankenPHP（PHP 8.3）上。
基于 [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) 模板（MIT，见 [LICENSE](LICENSE)）。

## 快速开始

```bash
cd api
docker compose up -d --wait     # app（HTTP 入口）+ worker（Messenger）+ db（Postgres 16）
curl -k https://localhost/healthz   # → {"status":"ok"}
```

开发环境端口：HTTPS `443`、HTTP `8080`（80 常被宿主机 Web 服务器占用，可用 `HTTP_PORT` 覆盖）。
Caddy 使用自签证书，浏览器访问 `https://localhost` 需信任一次（curl 加 `-k`）。

## 常用命令（都在容器内跑）

```bash
docker compose exec app composer check       # cs + phpstan(level 8) + phpunit，CI 同款门禁
docker compose exec app composer cs:fix      # 自动修复代码风格
docker compose exec app composer test:setup  # 创建/迁移测试库（首次跑测试前执行一次）
docker compose exec app composer test        # 只跑 PHPUnit
docker compose exec app bin/console doctrine:migrations:migrate
```

宿主机 PHP 版本可能高于容器（8.3），composer/质检请一律在容器内执行；
`composer.json` 已设 `config.platform.php=8.3.32` 兜底。

## 路由约定

- `GET /healthz` — 存活探针，公开无鉴权，检查 DB 连通（`src/Controller/HealthzController.php`）
- 业务 API 统一挂在 `/v1` 前缀下（API Platform，`config/routes/api_platform.yaml`）

## 环境变量与 secrets（SPEC §10.3）

加载顺序（后者覆盖前者，真实环境变量最优先）：

| 文件 | 入库 | 用途 |
|---|---|---|
| `.env` | ✅ | 全环境安全默认值（不放任何真实密钥） |
| `.env.local` | ❌ | 本机覆盖（git 已忽略） |
| `.env.test` | ✅ | 测试环境默认值 |

- **dev**：数据库等口令用 compose 默认值（`!ChangeMe!` 仅限本地）。
- **prod**：不部署 dotenv 文件，全部经真实环境变量注入（M0-05 的 `compose.prod.yaml` + 部署端 secrets）；
  后续敏感值（JWT 私钥、SMTP、FCM）用 Symfony secrets 或部署端 env 管理。
- 测试库自动带 `_test` 后缀（`config/packages/doctrine.yaml`），与 dev 库隔离；
  DAMA DoctrineTestBundle 让每个测试跑在回滚事务里。

## Compose 服务（SPEC §10.1）

| 服务 | 说明 |
|---|---|
| `app` | FrankenPHP + Caddy，HTTP 入口，自动 HTTPS |
| `worker` | 同镜像，`messenger:consume async`（邮件/推送异步任务，Doctrine transport） |
| `db` | `postgres:16`，数据卷持久化 |

`compose.yaml`（基础）+ `compose.override.yaml`（dev，自动加载）+ `compose.prod.yaml`（prod，M0-05 完善）。
