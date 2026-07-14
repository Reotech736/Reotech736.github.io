---
title: "環境変数"
slug: "environment-variable"
sort_key: "environment-variable"
summary: "プロセスへ外部から渡す名前と値の組で構成された設定情報"
category: "os"
aliases: ["Environment Variable"]
updated: 2026-07-14
---

## 一言でいうと
プロセスへ外部から渡す名前と値の組で構成された設定情報。

## より具体的には
アプリケーションのコードを変更せず、実行環境ごとに接続先や動作設定を切り替えられる。秘密情報を渡す用途にも使われるが、プロセス情報やログへの露出を考慮し、適切な秘密管理と組み合わせる必要がある。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
Botのトークンなどをコンテナイメージへ埋め込まず、実行時に渡すため使用している。

## 関連
- [Docker Compose](/terms/docker-compose/)
- [.dockerignore](/terms/dockerignore/)
