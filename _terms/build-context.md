---
title: "ビルドコンテキスト"
slug: "build-context"
sort_key: "びるどこんてきすと"
summary: "コンテナイメージのビルド時にビルダーへ渡されるファイル群"
category: "container"
aliases: ["Build Context","build context"]
updated: 2026-07-15
---

## 一言でいうと
コンテナイメージのビルド時にビルダーへ渡されるファイル群。

## より具体的には
通常はdocker buildで指定したディレクトリ配下が対象になり、DockerfileのCOPYなどから参照される。不要なファイルや秘密情報を含めると、転送量や漏えいリスクが増える。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
Botのイメージを作る際にDockerへ渡すファイルの範囲として説明している。

## 関連
- [Dockerfile](/terms/dockerfile/)
- [.dockerignore](/terms/dockerignore/)
- [コンテナイメージ](/terms/container-image/)
