---
title: "GitHub Actions"
slug: "github-actions"
sort_key: "github-actions"
summary: "GitHubリポジトリのイベントを契機にビルドやテストなどを自動実行する仕組み"
category: "development"
updated: 2026-08-08
---

## 一言でいうと
GitHubリポジトリのイベントを契機に、ビルド、テスト、デプロイなどの処理を自動実行する仕組み。

## より具体的には
リポジトリ内のYAMLファイルへ実行条件と複数の手順をワークフローとして定義する。pushやPull Request、定期実行、手動実行などを契機に、GitHubが提供するランナーまたはセルフホストランナー上で処理を実行できる。

外部サービスのトークンなどはリポジトリへ直接保存せず、Actions Secretsから環境変数として渡す。ワークフローに付与する権限も、処理に必要な範囲へ限定することが重要になる。

## 関連記事での使用例

### [Jekyllブログの記事をQiita CLIで自動ミラーする](/2026/08/08/qiita-cli-blog-mirroring.html)
mainブランチへマージされたQiita対象記事を検証し、Qiita CLIで投稿・更新する処理を自動化している。

## 関連
- [GitHub Pages](/terms/github-pages/)
- [Qiita CLI](/terms/qiita-cli/)
