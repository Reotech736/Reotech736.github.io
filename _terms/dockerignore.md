---
title: ".dockerignore"
slug: "dockerignore"
sort_key: "dockerignore"
summary: "Dockerのビルドコンテキストから不要なファイルを除外する設定ファイル"
category: "container"
aliases: ["dockerignore"]
updated: 2026-07-14
---

## 一言でいうと
Dockerのビルドコンテキストから不要なファイルを除外する設定ファイル。

## より具体的には
除外パターンを記述し、依存キャッシュ、Git管理情報、秘密情報などがビルダーへ送られるのを防ぐ。ビルドを軽量化し、意図しないCOPYや情報混入のリスクを下げる。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
node_modulesや.envをビルドコンテキストから除外するために使用している。

## 関連
- [ビルドコンテキスト](/terms/build-context/)
- [Dockerfile](/terms/dockerfile/)
- [環境変数](/terms/environment-variable/)
