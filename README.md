# OneCode

面向德国及欧洲用户的**卡券码钱包 App**：统一存储、管理、快速调出会员卡、优惠券等二维码/条形码，并支持与好友实时共享卡券。本地优先、离线可用、数据驻留欧盟、无广告无追踪。

## 仓库结构（Monorepo）

```
onecode/
  app/            # Flutter 客户端（iOS / Android）
  api/            # Symfony 后端（API Platform + PostgreSQL）
  SPEC.md         # 权威技术规格书（规格有变先改这里）
  .claude/tasks/  # 任务拆分与进度追踪
```

前后端与文档同仓：一次提交可同时改动客户端、后端与规格文档。CI 按路径过滤分别触发 `app/**` 与 `api/**` 流水线（见 SPEC §10.3）。

## 后端开发

```bash
cd api && docker compose up -d --wait
curl -k https://localhost/healthz   # → {"status":"ok"}
```

详见 [api/README.md](api/README.md)。

## 文档入口

- [SPEC.md](SPEC.md) — 技术规格书（产品定位、数据模型、同步协议、部署运维）
- [.claude/tasks/README.md](.claude/tasks/README.md) — 任务索引与使用约定（M0–M4 里程碑）
