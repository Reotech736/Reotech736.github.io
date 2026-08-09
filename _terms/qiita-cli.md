---
title: "Qiita CLI"
slug: "qiita-cli"
sort_key: "qiita-cli"
summary: "ローカルのMarkdown記事をプレビューしてQiitaへ投稿・更新できる公式コマンドラインツール"
category: "web"
updated: 2026-08-08
---

## 一言でいうと
ローカルのMarkdown記事をプレビューしてQiitaへ投稿・更新できる公式コマンドラインツール。

## より具体的には
記事本文と投稿設定をMarkdownファイルで管理し、ブラウザでのプレビュー、Qiitaからの記事取得、Qiitaへの新規投稿や更新をコマンドから行える。記事IDや更新日時もファイルへ保持できるため、Gitと組み合わせて執筆内容と公開履歴を管理しやすい。

Qiita用のfront matterと所定のディレクトリ構成を使用する。アクセストークンは記事ファイルへ埋め込まず、ローカルの認証情報やCIのシークレットとして管理する必要がある。

## 関連記事での使用例

### [Jekyllブログの記事をQiita CLIで自動ミラーする](/2026/08/08/qiita-cli-blog-mirroring.html)
Jekyll記事から生成したQiita用Markdownをプレビューし、GitHub Actionsから投稿・更新するために使用している。

## 関連
- [Markdown](/terms/markdown/)
- [GitHub Actions](/terms/github-actions/)
- [Jekyll](/terms/jekyll/)
