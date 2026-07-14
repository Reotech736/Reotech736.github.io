---
title: "Dockerボリューム"
slug: "docker-volume"
sort_key: "docker-volume"
summary: "コンテナのライフサイクルから分離してデータを保持する保存領域"
category: "container"
aliases: ["Docker Volume","ボリューム"]
updated: 2026-07-14
---

## 一言でいうと
コンテナのライフサイクルから分離してデータを保持する保存領域。

## より具体的には
Dockerが管理する領域をコンテナへマウントし、コンテナを削除・再作成しても必要なデータを残せる。ホストの特定パスを直接対応付ける方法はバインドマウントと呼ばれ、Docker管理ボリュームとは区別される。

## 関連記事での使用例

### [Docker環境の構築](/2026/01/21/docker-dev-setup.html)
コンテナ内のデータを永続化する仕組みとして紹介している。

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
Composeのvolumes設定でワールドデータをコンテナの再作成から分離している。この構成はホストパスを指定するバインドマウントを使用する。

## 関連
- [Docker](/terms/docker/)
- [コンテナ](/terms/container/)
- [バインドマウント](/terms/bind-mount/)
