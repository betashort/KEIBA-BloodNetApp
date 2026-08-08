# PostgreSQLのデータをNeo4jに変換する手順

---

## 1. データ変換の流れ

1. PostgreSQLからデータを抽出（CSVやJSONが一般的）
2. データをグラフ構造（ノード・リレーション）に整形
3. Neo4jにデータをインポート

---

## 2. サンプル・シナリオ

「馬」テーブル（horses）と「レース結果」テーブル（results）がある場合を例とします。

---

### (1) PostgreSQLからデータ抽出

```sql
-- ノードとなる馬データをCSVに出力
COPY (SELECT horse_id, name, birth_year FROM horses) TO '/tmp/horses.csv' CSV HEADER;

-- レースのリレーション用データをCSVに出力
COPY (SELECT horse_id, race_id, position FROM results) TO '/tmp/results.csv' CSV HEADER;
```

---

### (2) データをグラフデータ形式に整形

- horses.csv → ノード（:Horse）
- results.csv → 関係（:PARTICIPATED_IN）

---

### (3) Neo4jにデータインポート

#### 方法A: neo4j-admin import（大規模データ向け・初期構築時のみ）

```bash
neo4j-admin import \
  --nodes=Horse=/tmp/horses.csv \
  --relationships=PARTICIPATED_IN=/tmp/results.csv
```

#### 方法B: CypherでCSV読み込み（稼働中DBや小規模向け）

1. horses.csvをインポート

```cypher
LOAD CSV WITH HEADERS FROM 'file:///horses.csv' AS row
MERGE (h:Horse {horse_id: row.horse_id})
SET h.name = row.name, h.birth_year = row.birth_year;
```

2. results.csvをインポート

```cypher
LOAD CSV WITH HEADERS FROM 'file:///results.csv' AS row
MATCH (h:Horse {horse_id: row.horse_id})
MERGE (r:Race {race_id: row.race_id})
MERGE (h)-[p:PARTICIPATED_IN]->(r)
SET p.position = row.position;
```

※ `file:///` で指定したパスはNeo4jサーバの`import`ディレクトリ配下にファイルを置く必要があります。

---

## 3. Pythonスクリプトで自動化する場合

PythonならpandasでPostgreSQLからデータ抽出し、そのままNeo4jドライバ経由で投入も可能。

```python
import pandas as pd
from sqlalchemy import create_engine
from neo4j import GraphDatabase

# PostgreSQLからデータ取得
engine = create_engine('postgresql://user:password@localhost:5432/dbname')
horses = pd.read_sql('SELECT horse_id, name, birth_year FROM horses', engine)
results = pd.read_sql('SELECT horse_id, race_id, position FROM results', engine)

# Neo4jにデータ投入
driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "password"))

def import_horses(tx, row):
    tx.run(
        "MERGE (h:Horse {horse_id: $horse_id}) "
        "SET h.name = $name, h.birth_year = $birth_year",
        horse_id=row["horse_id"], name=row["name"], birth_year=row["birth_year"]
    )

def import_results(tx, row):
    tx.run(
        "MATCH (h:Horse {horse_id: $horse_id}) "
        "MERGE (r:Race {race_id: $race_id}) "
        "MERGE (h)-[p:PARTICIPATED_IN]->(r) "
        "SET p.position = $position",
        horse_id=row["horse_id"], race_id=row["race_id"], position=row["position"]
    )

with driver.session() as session:
    for _, row in horses.iterrows():
        session.write_transaction(import_horses, row)
    for _, row in results.iterrows():
        session.write_transaction(import_results, row)
driver.close()
```

---

## 4. 補足

- スキーマ設計（どのテーブルをノード/リレーションにするか）は事前に設計しておくとスムーズです。
- 大規模移行ならバッチ的に、日次で差分をグラフ反映したい場合などはPython等で抽出～投入を一連でつなげるのが一般的です。

---