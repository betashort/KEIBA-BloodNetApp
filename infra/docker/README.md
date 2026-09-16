# ローカル Docker 環境（P0）

データストア（PostgreSQL 16 ＋ Neo4j 5.26 LTS）を起動する。設計の正は [../../doc/02_design/environment.md](../../doc/02_design/environment.md)。

## 起動

リポジトリルートで:

```bash
cp infra/docker/.env.example infra/docker/.env
docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml up -d
# またはリポジトリルートで: make up
```

| サービス | URL / 接続 |
| -------- | ---------- |
| PostgreSQL | `127.0.0.1:5432` / DB `bloodnet` / ユーザは `.env` |
| Neo4j Browser | http://localhost:7474 |
| Neo4j Bolt | `bolt://localhost:7687` |

停止: 同じファイル指定で `down`。データを消すときだけ `down -v`。
