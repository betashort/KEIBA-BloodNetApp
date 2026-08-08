# Neo4j 体系的解説

## 1. Neo4jとは

Neo4j が開発している、代表的な**グラフデータベース**です。

通常のRDB（PostgreSQLやMySQL）が「表（テーブル）」でデータを管理するのに対し、Neo4jは：

* ノード（点）
* リレーションシップ（線）
* プロパティ（属性）

でデータを表現します。

特に以下に強いです。

* 人間関係
* ネットワーク構造
* 血統
* 推薦システム
* 経路探索
* 知識グラフ
* 因果関係
* GNN前処理

---

## 2. グラフデータベースとは

### RDBの世界

例えば競馬DB：

```text
horses
+----+--------+
| id | name   |
+----+--------+
| 1  | ディープ |
+----+--------+
```
```txt
pedigree
+----------+-----------+
| child_id | father_id |
+----------+-----------+
| 10       | 1         |
+----------+-----------+
```

JOINで辿る必要があります。

---

### グラフDBの世界

```text
(ディープインパクト)-[:FATHER_OF]->(コントレイル)
```

関係そのものを保存します。

つまり：

**「繋がり」が主役**

です。

---

## 3. Neo4jの基本構造

### ノード（Node）

エンティティ。

例：

```text
(Horse)
(Jockey)
(Race)
```

イメージ：

```text
(:Horse {name:"イクイノックス"})
```

---

### リレーションシップ（Relationship）

ノード間の関係。

```text
(:Horse)-[:FATHER_OF]->(:Horse)
```

種類例：

* FATHER_OF
* MOTHER_OF
* RAN_IN
* WON
* TRAINED_BY

---

### プロパティ（Property）

属性情報。

```text
(:Horse {
    name: "イクイノックス",
    sex: "牡",
    birth_year: 2019
})
```

---

### ラベル（Label）

ノードの分類。

```text
(:Horse)
(:Race)
(:Person)
```

RDBのテーブルに近い概念。

---

## 4. Neo4jが得意な処理

### ① 多段探索

### 例

* 5代血統探索
* 母系探索
* クロス探索

RDBだとJOIN地獄。

Neo4jは高速。

---

### ② 経路探索

例えば：

* 同系統探索
* サンデーサイレンス系統
* インブリード経路

---

### ③ 関係性分析

例えば：

* 同騎手
* 同厩舎
* 同配合傾向

---

## 5. Neo4jの内部思想

### 「Index-Free Adjacency」

Neo4j最大の特徴。

各ノードが：

**次に繋がるノードへのポインタを直接持つ**

ため、高速に辿れます。

RDB：

```text
index lookup → join → join → join
```

Neo4j：

```text
pointer → pointer → pointer
```

---

## 6. Cypherクエリ言語

Neo4j専用SQL。

非常に読みやすい。

---

### ノード作成

```cypher
CREATE (:Horse {name:"イクイノックス"})
```

---

### 関係作成

```cypher
MATCH (p:Horse {name:"キタサンブラック"})
MATCH (c:Horse {name:"イクイノックス"})
CREATE (p)-[:FATHER_OF]->(c)
```

---

### 検索

```cypher
MATCH (h:Horse)
RETURN h
```

---

### 血統探索

```cypher
MATCH (h:Horse {name:"イクイノックス"})<-[:FATHER_OF*1..5]-(ancestor)
RETURN ancestor
```

これは：

> 5代祖先探索

です。

---

## 7. 競馬血統DBとの相性

競馬血統は典型的グラフ構造です。

### 血統ツリー

```text
サンデーサイレンス
    ↓
ディープインパクト
    ↓
コントレイル
```

Neo4jはこれを自然に表現できます。

---

## 8. 競馬向けおすすめスキーマ

### ノード

```text
(:Horse)
(:Race)
(:Jockey)
(:Trainer)
(:Farm)
```

---

### リレーション

```text
(:Horse)-[:FATHER_OF]->(:Horse)
(:Horse)-[:MOTHER_OF]->(:Horse)

(:Horse)-[:RAN_IN]->(:Race)

(:Horse)-[:RIDDEN_BY]->(:Jockey)

(:Horse)-[:TRAINED_BY]->(:Trainer)
```

---

## 9. 血統分析で強い分析

### インブリード解析

```text
Northern Dancer 4x4
```

共通祖先探索が容易。

---

### 系統クラスタリング

例えば：

* Storm Cat 系
* Roberto 系
* Halo 系

---

### 配合理論分析

例えば：

* サンデー×ミスプロ
* ナスルーラクロス

---

## 10. Graph Data Science (GDS)

Neo4j最大の武器。

### GDSとは

グラフアルゴリズムライブラリ。

---

### 主なアルゴリズム

#### PageRank

重要血統探索。

---

#### Node2Vec

馬の埋め込みベクトル化。

競馬AIと相性が良い。

---

#### Louvain

血統クラスタ検出。

---

#### Similarity

似た競走馬探索。

---

## 11. 機械学習との連携

Neo4jはAIと非常に相性が良いです。

### 特徴量生成

例：

* 血統距離
* 祖先重要度
* 系統クラスタ
* ネットワーク中心性

---

### GNN前処理

競馬GNNでは：

```text
馬 = ノード
血統 = エッジ
```

として利用可能。

---

## 12. Neo4jアーキテクチャ

### 主な構成

#### Neo4j DBMS

データベース本体。

---

#### Browser

GUIクエリエディタ。

---

#### Bloom

可視化ツール。

---

#### GDS Library

グラフ分析ライブラリ。

---

## 13. 導入方法

## Docker推奨

```yaml
services:
  neo4j:
    image: neo4j:latest
    ports:
      - "7474:7474"
      - "7687:7687"
    environment:
      NEO4J_AUTH: neo4j/password
```

---

### アクセス

```text
http://localhost:7474
```

---

## 14. Python連携

### ドライバ

```bash
pip install neo4j
```

---

### 接続

```python
from neo4j import GraphDatabase

driver = GraphDatabase.driver(
    "bolt://localhost:7687",
    auth=("neo4j", "password")
)
```

---

## 15. PostgreSQLとの使い分け

| 項目   | PostgreSQL | Neo4j |
| ---- | ---------- | ----- |
| 集計   | 強い         | 普通    |
| JOIN | 普通         | 非常に強い |
| 関係探索 | 弱い         | 最強    |
| 血統探索 | 大変         | 得意    |
| 経路探索 | 苦手         | 得意    |
| 数値分析 | 強い         | 普通    |

---

## 16. 実運用で多い構成

かなり多いのが：

```text
PostgreSQL
    ↓
Neo4jへ同期
```

役割分担：

### PostgreSQL

* レース結果
* 数値集計
* 大量データ

---

### Neo4j

* 血統
* 関係性
* ネットワーク分析

---

## 17. 学習ロードマップ

### 初級

1. Node
2. Relationship
3. Cypher

---

## 中級

1. 可変長パス
2. shortestPath
3. path analysis

---

## 上級

1. GDS
2. Node2Vec
3. Graph ML
4. Knowledge Graph
5. GNN

---

# 18. 競馬向け最終形

あなたのケースだと最終的に：

```text
JRAデータ
    ↓
PostgreSQL
    ↓
Neo4j
    ↓
GDS
    ↓
LightGBM / GNN
```

の構成がかなり強いです。