# KEIBA-BloodNetApp

競走馬の血統をグラフとして管理・可視化するシステムの R&D リポジトリ。

一次ストアは PostgreSQL、血統探索の正は Neo4j。初期はローカル Docker で動かす。

## ドキュメント

| 文書 | 内容 |
| ---- | ---- |
| [doc/01_rd](./doc/01_rd) | 要求仕様・ユースケース |
| [doc/02_design](./doc/02_design) | アーキテクチャ・ベース設計・データモデル・**動作環境** |
| [doc/02_design/environment.md](./doc/02_design/environment.md) | システム動作環境と開発環境の構築 |
| [doc/research](./doc/research) | Neo4j / ETL / 血統分析の調査メモ |

## 開発環境（P0: データストア）

前提: Docker Engine ＋ Compose V2、メモリ 8 GB 以上推奨。

```bash
cp infra/docker/.env.example infra/docker/.env
docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml up -d
# または: make up
```

- PostgreSQL: `127.0.0.1:5432`（架空のサンプル馬が入る）
- Neo4j Browser: http://localhost:7474
- 手順の詳細: [doc/02_design/environment.md](./doc/02_design/environment.md)

API / UI / ETL は P0〜P1 で追加する。認証情報は `.env` に置き、リポジトリへコミットしない。
