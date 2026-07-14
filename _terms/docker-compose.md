---
title: "Docker Compose"
slug: "docker-compose"
sort_key: "docker-compose"
summary: "複数コンテナの構成と起動方法を宣言的に管理するDockerの機能"
category: "container"
aliases: ["Compose","docker compose"]
updated: 2026-07-14
---

## 一言でいうと
複数コンテナの構成と起動方法を宣言的に管理するDockerの機能。

## より具体的には
YAMLファイルにサービス、ネットワーク、ボリューム、環境変数などを記述し、一組のアプリケーションとして起動・停止できる。手作業の長いコマンドを減らし、構成を再現しやすくする。

## 関連記事での使用例

### [Docker環境の構築](/2026/01/21/docker-dev-setup.html)
UbuntuへComposeプラグインを導入し、docker composeコマンドを使える状態にしている。

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
単一コンテナの起動方法から発展させて、構成をファイルで管理する選択肢になる。

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
2つのMinecraftワールドを別サービスとして定義し、まとめて運用するために使用している。

## 関連
- [Docker](/terms/docker/)
- [Dockerボリューム](/terms/docker-volume/)
- [環境変数](/terms/environment-variable/)
