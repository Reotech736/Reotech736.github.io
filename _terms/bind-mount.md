---
title: "バインドマウント"
slug: "bind-mount"
sort_key: "bind-mount"
summary: "ホスト上の特定パスをコンテナ内のパスへ直接対応付ける方法"
category: "container"
aliases: ["Bind Mount","bind mount"]
updated: 2026-07-14
---

## 一言でいうと
ホスト上の特定パスをコンテナ内のパスへ直接対応付ける方法。

## より具体的には
ホスト側のファイルやディレクトリをコンテナからそのまま読み書きできる。設定ファイルの共有や開発中のコード反映に便利だが、ホストのパス構成や権限に依存する。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
変更されるsettings.jsonをイメージから分離し、ホスト側で管理するために使用している。

## 関連
- [Dockerボリューム](/terms/docker-volume/)
- [コンテナ](/terms/container/)
- [Docker](/terms/docker/)
