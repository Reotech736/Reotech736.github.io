---
name: create-blog-thumbnail
description: Reo's Tech Blogの既存デザインに合わせ、Jekyllで処理できる1200x630のSVGサムネイルを新規作成・修正する。ブログ記事のthumbnail.svg、OGP画像、タイトル改行、配色ローテーション、主題アイコンの作成や既存サムネイルとの統一を依頼されたときに使用する。
---

# ブログサムネイル作成

記事の主題が一覧で伝わるSVGを、既存投稿と同じレイアウト規則で作成する。作業前に[サムネイルのスタイル基準](references/thumbnail-style.md)を読む。

## 記事と既存デザインを確認する

1. 対象記事のtitle、slug、thumbnail指定、主題を確認する。
2. 投稿日順で直近のサムネイルを少なくとも3件確認する。
3. 直近記事の配色から、5種類のパレットローテーションの次色を選ぶ。既存サムネイルの修正では元の配色を維持する。
4. `_includes/thumbnail-title-lines.svg`の現在のインターフェースを確認する。

## SVGを設計する

- `assets/images/posts/<slug>/thumbnail.svg`へ配置する。
- `1200x630`、`viewBox="0 0 1200 630"`で作成する。
- 左側に上部ラベル、タイトル、短い補足を置き、右側に主題を表すアイコンを1つ置く。
- タイトルはSVG先頭の`thumbnail_title_lines`で1〜2行に分け、共通includeで描画する。固定のタイトル`<text>`を重複して書かない。
- タイトル表示は記事タイトルを基準にし、必要なら意味を変えない範囲でサムネイル用に短くする。
- 右側のアイコンは記事固有の主題が分かる単純なベクター図形とする。既存記事のアイコンをそのまま流用しない。
- 外部画像、秘密情報、商標ロゴの無断コピー、細かすぎて縮小時に読めない要素を入れない。

## 記事へ設定する

1. 記事front matterの`thumbnail`を`/assets/images/posts/<slug>/thumbnail.svg`へ設定する。
2. 既存の画像ディレクトリやslugと競合しないことを確認する。
3. SVGのYAML front matter、Liquid include、XMLを既存のインデントに合わせる。

## 検証する

- `JEKYLL_ENV=production bundle exec jekyll build`を実行する。
- `_site/assets/images/posts/<slug>/thumbnail.svg`にYAML front matterや未展開Liquidが残っていないことを確認する。
- 生成SVGが`1200x630`で、タイトルの各行と選択したパレットが反映されていることを確認する。
- ローカル表示またはブラウザで、記事ヒーロー、ブログ一覧、タグ一覧の縮小表示を確認する。
- 長いタイトルの切れ、アイコンとの重なり、低コントラスト、記事front matterの画像パス誤りを確認する。
- `git diff --check`と`git status --short`で変更範囲を確認する。
