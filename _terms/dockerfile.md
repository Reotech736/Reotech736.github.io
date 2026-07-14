---
title: "Dockerfile"
slug: "dockerfile"
sort_key: "dockerfile"
summary: "コンテナイメージの作り方を記述するファイル"
category: "container"
updated: 2026-07-14
---

## 一言でいうと
コンテナイメージの作り方を記述するファイル。

## より具体的には
Dockerfile は、どのベースイメージを使うか、どのファイルをコピーするか、どのコマンドを実行するかを順番に書いて、コンテナイメージを組み立てるための定義ファイル。  
アプリケーションの実行環境をコードとして管理できるため、ローカルと本番の差を減らしやすい。

`FROM`, `COPY`, `RUN`, `CMD` などの命令を使って、必要なパッケージや起動コマンドを明示する。  
コンテナ運用の入口になる概念。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
Node.js製Botの依存関係と起動方法をコンテナイメージとして定義するため使用している。

## 関連
- [ビルドコンテキスト](/terms/build-context/)
- [コンテナイメージ](/terms/container-image/)
- [コンテナ](/terms/container/)
