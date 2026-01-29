# Reotech Homepage

Jekyll + GitHub Pagesで構築された技術ブログサイトです

## URL
https://reotech736.com/

## 技術スタック
- Jekyll (静的サイトジェネレーター)
- GitHub Pages (ホスティング)
- Markdown (記事作成)

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
bundle exec jekyll serve --host 0.0.0.0 --livereload
```

4. ブラウザで確認
```
http://localhost:4000
```

### よく使うコマンド

```bash
# ローカルサーバー起動（自動リロード有効、WSL対応）
bundle exec jekyll serve --host 0.0.0.0 --livereload

# ドラフトも含めてビルド
bundle exec jekyll serve --host 0.0.0.0 --drafts

# 本番環境と同じ設定でビルド
JEKYLL_ENV=production bundle exec jekyll build
```

**注意:** WSL環境で開発する場合は `--host 0.0.0.0` オプションが必要です
これによりWindowsホスト側からもアクセスできるようになります

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
