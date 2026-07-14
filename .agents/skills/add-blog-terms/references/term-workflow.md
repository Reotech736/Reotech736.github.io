# 技術メモの品質基準

## Front Matter

正本は`knowledge-vault-work/01_terms/<slug>.md`に置く。

```yaml
---
title: 表示名
type: term
publish: true
slug: ascii-kebab-case
sort_key: ascii-kebab-case
aliases:
  - 略称
category: monitoring
tags:
  - monitoring
summary: 一覧で意味が分かる一文
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: manual
status: draft
---
```

- `sort_key`は`slug`と異なる並び順が必要な場合に設定する。
- `aliases`は略称、正式名称、一般的な別表記だけに使う。
- 既存カテゴリを優先する。主なカテゴリは`aws`、`container`、`shell`、`monitoring`、`ai`、`network`。
- 公開を依頼されていない下書きは`publish: false`を維持する。

## 本文構造

```markdown
# 用語名

## 一言でいうと
用語を初めて見る読者向けの一文。

## より具体的には
一般的な仕組み、用途、責務、注意点。

## 関連記事での使用例

### [記事タイトル](/YYYY/MM/DD/article-slug.html)
その記事での役割や採用理由。

## 関連
- [[関連用語]]
```

関連記事がない場合は`関連記事での使用例`自体を作らない。一般説明だけで独立して理解できることを優先する。

## 品質チェック

- 特定記事を読んでいなくても`一言でいうと`と`より具体的には`を理解できる。
- 記事固有の固有名詞、URL、構成判断は記事タイトルの配下だけにある。
- 略称だけの重複ノートがない。
- 関連wiki linkの表記が正本の`title`または`aliases`と一致する。
- 記事側のリンクは初出のみで、リンクだらけになっていない。
- 秘密情報、アカウントID、内部URL、認証情報を含まない。
