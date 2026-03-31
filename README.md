# Reotech Homepage

Jekyll + GitHub Pagesで構築された技術ブログサイトです

## URL
https://reotech736.com/

## 技術スタック
- Jekyll (静的サイトジェネレーター)
- GitHub Pages (ホスティング)
- GitHub Actions (Pages deploy / contributions SVG 更新)
- Markdown (記事作成)

## コンテンツ構成
- `_posts/`: 個人開発記録として扱う整理済みのブログ記事
- `_study_logs/`: `knowledge-vault-work/03_study_logs` から変換される学習記録
- `_terms/`: `knowledge-vault-work/01_terms` から変換される技術メモ

## ローカル開発環境のセットアップ

### 必要な環境
- Ruby (2.7以上推奨)
- Bundler

### セットアップ手順

1. リポジトリをクローン
```bash
git clone git@github.com:Reotech736/Reotech736.github.io.git
cd Reotech736.github.io
```

2. 依存関係をインストール
```bash
bundle install
```

3. ローカルサーバーを起動（WSL環境推奨）
```bash
bundle exec jekyll serve --host 0.0.0.0 --drafts
```

4. ブラウザで確認
```
http://localhost:4000
```

### よく使うコマンド

```bash
# knowledge-vault の学習記録を取り込む
ruby scripts/import-study-logs.rb

# knowledge-vault の技術メモを取り込む
ruby scripts/import-terms.rb

# LAN確認向け（推奨: 高速）
bundle exec jekyll serve --host 0.0.0.0 --drafts

# ローカルPCのみで自動リロードしたい場合
bundle exec jekyll serve --livereload

# 本番環境と同じ設定でビルド
JEKYLL_ENV=production bundle exec jekyll build
```

## knowledge-vault 連携

このリポジトリは、Linux server 上の `knowledge-vault-work` を公開用 Markdown に変換して取り込む想定です。

- 学習記録: `knowledge-vault-work/03_study_logs/*.md`
- 技術メモ: `knowledge-vault-work/01_terms/*.md`

変換対象は、どちらも `publish: true` のノートだけです。

基本手順:

```bash
ruby scripts/import-study-logs.rb
ruby scripts/import-terms.rb
JEKYLL_ENV=production bundle exec jekyll build
```

変換スクリプトは vault 側の front matter を見て、Jekyll 用 front matter を付与した Markdown を `_study_logs/` と `_terms/` に書き出します。
source of truth は `knowledge-vault-work` 側です。ブログ repo 側の生成ファイルを手で編集する前提にはしません。

## デプロイ

`main` ブランチへの push を契機に、GitHub Actions で Jekyll build と GitHub Pages への deploy を行います。
Pages の公開元は branch deploy ではなく `GitHub Actions` を使う前提です。

関連 workflow:

- `.github/workflows/deploy-pages.yml`
- `.github/workflows/update-contributions.yml`

**注意:** WSL環境で開発する場合は `--host 0.0.0.0` オプションが必要です
これによりWindowsホスト側からもアクセスできるようになります

**補足:** `--livereload` は環境によっては遅延や不安定化の原因になります。  
LAN内の別PCから確認する用途では、`--livereload` なし（上記の推奨コマンド）を使ってください。

## 記事の作成方法

1. `_posts`ディレクトリに新しいファイルを作成
   - ファイル名の形式: `YYYY-MM-DD-title.md`
   - 例: `2025-11-26-my-first-post.md`

2. Front Matterを追加
```markdown
---
layout: post
title: "記事のタイトル"
date: 2025-11-26 12:00:00 +0900
tags: [tag1, tag2]
---

ここに記事の内容を書く
```

## サムネイル運用（グラデーション統一）

サムネイルは **サイト全体の色味に合わせた寒色系グラデーション**で統一しています。  
新規投稿でも全体のグラデーションが崩れないよう、**色はローテーション**して使います。

### ルール

- 画像サイズは **1200x630**（OGP比率）
- ファイルは `assets/images/posts/<slug>/thumbnail.svg`
- Front Matter に `thumbnail` を指定
- 1記事につき **1ポイントアイコン**を入れる（主題が一目で分かるもの）
- 既存の配色順に合わせて **次の色セット**を使う

### パレット（ブログのイメージカラー由来）

以下の順で **投稿順にローテーション**します（次の投稿は次の色へ）。

1. `#024450 → #7eb3bf`
2. `#087b8a → #036982`
3. `#036982 → #024450`
4. `#3ba3c5 → #087b8a`
5. `#7eb3bf → #3ba3c5`

### 設定例

```markdown
---
layout: post
title: "新しい記事"
date: 2026-02-01 00:00:00 +0900
tags: [Docker]
thumbnail: /assets/images/posts/2026-02-01-new-post/thumbnail.svg
---
```

## タグ運用（専用ページを作る方針）

このサイトでは、記事内のタグクリック時に **タグ専用ページ**（`/tags/<slug>/`）へ遷移する運用にしています  
そのため、新しいタグを使うときは **タグ定義** と **タグページ** を必ず追加します

### 1) タグ定義を追加（_data/tags.yml）

`_data/tags.yml` に `name`（記事で使うタグ名）と `slug`（URL用）を追加します

例（Docker の場合）:

```yml
- name: Docker
  slug: docker
```

※ `name` は Front Matter の `tags: [...]` と **完全一致**させます（大小文字/スペースも含む）

### 2) タグページを追加（tags/<slug>.html）

`tags/<slug>.html` を作成します（中身は Front Matter のみでOK）

例（Docker の場合）:

```markdown
---
layout: tag
title: "Docker"
tag: Docker
permalink: /tags/docker/
---
```

3. ローカルで確認後、コミット＆プッシュ

## ブランチ戦略

詳細は [CONTRIBUTING.md](CONTRIBUTING.md) を参照してください
