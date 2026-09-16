-- KEIBA-BloodNetApp: 論理馬マスタ（base_design §4.3）
-- ボリューム新規作成時のみ実行される。
-- 実 JV-DL データは置かない。架空馬による 5 代＋ 4×4 クロス検証用。

CREATE TABLE horses (
    horse_id    VARCHAR(32) PRIMARY KEY,
    name        VARCHAR(128) NOT NULL,
    name_en     VARCHAR(128),
    sex         VARCHAR(8),
    birth_year  INTEGER,
    father_id   VARCHAR(32),
    mother_id   VARCHAR(32),
    synced_at   TIMESTAMPTZ
);

CREATE INDEX idx_horses_name ON horses (name);
CREATE INDEX idx_horses_father_id ON horses (father_id);
CREATE INDEX idx_horses_mother_id ON horses (mother_id);

COMMENT ON TABLE horses IS '一次ストアの馬マスタ。父母は ID 参照（欠落可、ダミー行は作らない）';

-- サンプルヒーロー (SMPL000001) の血統:
--   父系 4 代目と母父系 4 代目に Northern Dancer 相当（SMPL000ND1）が現れ、4×4 になる。
INSERT INTO horses (horse_id, name, name_en, sex, birth_year, father_id, mother_id, synced_at) VALUES
    ('SMPL000ND1', 'サンプルダンサー', 'Sample Dancer', '牡', 1961, NULL, NULL, NOW()),
    ('SMPL000041', 'サンプルアンカA',  NULL, '牝', 1963, NULL, NULL, NOW()),
    ('SMPL000042', 'サンプルアンカB',  NULL, '牝', 1962, NULL, NULL, NOW()),
    ('SMPL000043', 'サンプルメイトC',  NULL, '牝', 1964, NULL, NULL, NOW()),
    ('SMPL000044', 'サンプルメイトD',  NULL, '牝', 1965, NULL, NULL, NOW()),
    ('SMPL000031', 'サンプルノーザンA', NULL, '牡', 1985, 'SMPL000ND1', 'SMPL000041', NOW()),
    ('SMPL000032', 'サンプルクイーンA', NULL, '牝', 1986, NULL, 'SMPL000043', NOW()),
    ('SMPL000033', 'サンプルノーザンB', NULL, '牡', 1984, 'SMPL000ND1', 'SMPL000042', NOW()),
    ('SMPL000034', 'サンプルクイーンB', NULL, '牝', 1987, NULL, 'SMPL000044', NOW()),
    ('SMPL000021', 'スピードライン',   NULL, '牡', 1998, 'SMPL000031', 'SMPL000032', NOW()),
    ('SMPL000022', 'ハートライン',     NULL, '牝', 1999, NULL, NULL, NOW()),
    ('SMPL000023', 'パワーライン',     NULL, '牡', 1997, 'SMPL000033', 'SMPL000034', NOW()),
    ('SMPL000024', 'ステイライン',     NULL, '牝', 2000, NULL, NULL, NOW()),
    ('SMPL000011', 'サンプルサイアー', NULL, '牡', 2008, 'SMPL000021', 'SMPL000022', NOW()),
    ('SMPL000012', 'サンプルダム',     NULL, '牝', 2009, 'SMPL000023', 'SMPL000024', NOW()),
    ('SMPL000001', 'サンプルヒーロー', NULL, '牡', 2016, 'SMPL000011', 'SMPL000012', NOW());
