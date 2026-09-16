# 02 Design — 設計

要求仕様（[../01_rd](../01_rd)）を満たすための設計ドキュメントを置く。

## 文書構成

| 文書 | 内容 |
| ---- | ---- |
| [architecture.md](./architecture.md) | システムアーキテクチャ（構成・データフロー・横断関心事） |
| [base_design.md](./base_design.md) | ベース設計（モジュール・ETL・API・UI・技術仮決め） |
| [data_model.md](./data_model.md) | グラフデータモデル（ノード／リレーション／属性） |
| [environment.md](./environment.md) | システム動作環境・開発環境の構築（ホスト、ミドルウェア、Compose） |

## 読み順（推奨）

1. [../01_rd/requirements.md](../01_rd/requirements.md) … 何を満たすか
2. [architecture.md](./architecture.md) … どう分割し、どう流すか
3. [base_design.md](./base_design.md) … モジュールと API／画面の基本形
4. [data_model.md](./data_model.md) … グラフ上の具体スキーマ
5. [environment.md](./environment.md) … 何の上で動かし、どう立ち上げるか

## 関連

- 要求・要件: [../01_rd/requirements.md](../01_rd/requirements.md)
- ユースケース: [../01_rd/use_cases.md](../01_rd/use_cases.md)
- 調査メモ: [../research](../research)
