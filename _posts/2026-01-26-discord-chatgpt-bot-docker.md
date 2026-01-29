---
layout: post
title: "Discord Bot を Docker で常駐運用する"
thumbnail: /assets/images/posts/2026-01-26-discord-chatgpt-bot-docker/thumbnail.svg
date: 2026-01-26 00:00:00 +0900
author: Reo Komatsubara
tags: [Ubuntu, Docker, Discord]
---

## はじめに

[前回の記事「Docker環境の構築」]({% post_url 2026-01-21-docker-dev-setup %})で Docker 環境までは構築できたので、今回は **実際のアプリをコンテナ化**します  
題材は「Discord 上で動く ChatGPT Bot（Node.js）」です（厳密には “Discord サーバ” ではなく “Discord Bot” のコンテナ化です）

この記事のゴールは次の 3 つです

- いままでターミナルで直接起動していた Bot を Docker コンテナとして常駐させる
- 秘密情報（トークン）や設定ファイルを、イメージと分離して運用できるようにする
- 運用・更新（ログ確認、再起動、自動起動）を Docker コマンドで揃える

## なぜコンテナ化するのか

今までの「サーバに入ってターミナルで `npm start`」運用は、次のような “事故りポイント” がありました

- 端末（RDP/SSH）を閉じると止まりがちで常駐できない
- Node.js のバージョン差分や依存関係で、別環境に移したとき再現しにくい

Docker 化すると、起動と管理が **「コンテナ」** という単位に揃うので、運用がかなり楽になります

- 起動・停止・ログ確認が `docker ...` に統一される
- `--restart unless-stopped` で自動起動できるため、サーバ再起動後も復旧しやすい
- アプリの実行環境（Node.js / 依存関係）がイメージとして固定される
- 秘密情報（トークン）と設定（settings.json）をホスト側で管理し、差し替えできる

## Bot の事前確認事項

使用する Bot のリポジトリは [こちら（GitHub）](https://github.com/Reotech736/discord-chatgpt-bot) です

この Bot は以下を前提にしています（Docker 化に効いてくる部分だけ抜粋）

- Node.js で動作し、起動は `npm start`
- `.env` に `DISCORD_TOKEN` と `OPENAI_API_KEY` を置く
- モデル選択や履歴 ON/OFF の設定を `settings.json` に保存（このファイルは永続化が必要）

## アーキテクチャ図

今回、構築予定の全体像です  
黄色がホスト（Ubuntu Server + Docker Engine）、緑が Bot コンテナです  
`.env` と `settings.json` はホスト側で管理して、起動時に渡す/マウントします

![discord-chatgpt-bot architecture](/assets/images/posts/2026-01-26-discord-chatgpt-bot-docker/discord-chatgpt-bot-architecture.svg)

## Dockerfile（コンテナの設計図）

今回の Dockerfile は「Node.js の公式イメージをベースに、依存関係を入れて起動する」というシンプルな形です  
ポイントは **キャッシュが効く順序**と、**root ではなく node ユーザーで動かす**ことです

```Dockerfile
FROM node:18-slim

WORKDIR /app

# 依存関係だけ先にコピー（ここがキャッシュに効く）
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# アプリ本体をコピー
COPY . .

# 非 root 実行のために権限を調整
RUN chown -R node:node /app
USER node

CMD ["npm", "start"]
```

### Tips: なぜ `COPY package*.json` を先にやるのか

アプリのソースコードが変わっても、依存関係が変わらない限り `npm ci` のレイヤーをキャッシュできるため、ビルドが速くなります  
（逆に最初に `COPY . .` してしまうと、ちょっとした変更でも毎回依存インストールが走りがちです）

### Tips: なぜ非 root（`USER node`）で動かすのか

コンテナの中とはいえ root で動かすと、万一の侵入時に影響が大きくなります  
公式の `node` イメージには `node` ユーザーが最初から用意されているので、素直にそれを使うのが手軽です

## `.dockerignore`（ビルドに不要なものを除外する）

Docker はビルド時に “ビルドコンテキスト” としてディレクトリ一式を送るので、不要なものは最初から除外します  
とくに `.env` と `node_modules` を入れないのが重要です

```txt
node_modules
npm-debug.log
.env
.git
.gitignore
workspace
```

### Tips: `.env` を `.dockerignore` に入れる理由

- **ビルドコンテキストに入れない**ため（誤って `COPY . .` でイメージに混ざるのを防ぐ）
- `.env` は環境ごとに違い、またトークンなど秘密情報が含まれるので、イメージの設計図（Dockerfile）から分離したい

## 環境変数の渡し方（そして Dockerfile に含めない理由）

この Bot は `DISCORD_TOKEN` と `OPENAI_API_KEY` が必要です  
これらは **Dockerfile に書かず、起動時に渡します**

例：`.env`

```env
DISCORD_TOKEN=xxxxxxxx
OPENAI_API_KEY=xxxxxxxx
```

起動（`--env-file` を使う）

```bash
docker run -d --name discord-chatgpt-bot \
  --env-file .env \
  -v "$PWD/settings.json:/app/settings.json" \
  --restart unless-stopped \
  discord-chatgpt-bot:1.0
```

### Tips: なぜ環境変数を Dockerfile に含めないのか

結論：**秘密情報をイメージに焼き込まない**ためです

- イメージは配布・共有され得る（秘密情報を含めると漏えいリスクが跳ね上がる）
- Dockerfile の `ENV` や `ARG` は、ビルドキャッシュや履歴・レイヤーから追跡される可能性がある
- 本番/検証/開発でキーを切り替えたい（起動時に差し替えた方が運用が楽）

## 設定ファイルの永続化（`settings.json`）

この Bot はモデル選択や履歴 ON/OFF を `settings.json` に保存します  
コンテナは作り直す前提の仕組みなので、ファイルをコンテナ内に置きっぱなしにすると消えます

そこで、`settings.json` はホスト側に置いて、コンテナに **バインドマウント**します

```bash
-v "$PWD/settings.json:/app/settings.json"
```

### Tips: マウントは “必要最小限” にする

ホストのパスをマウントした分だけ、コンテナからホストのファイルに触れられます  
今回は `settings.json` だけをマウントし、範囲を最小化します（安全・管理の両面でメリットがあります）

## ビルドと起動（手順まとめ）

### 1) イメージをビルド

```bash
docker build -t discord-chatgpt-bot:1.0 .
```

`permission denied while trying to connect to the docker API` が出る場合は、`sudo docker ...` で実行するか、ユーザーを `docker` グループに追加します

### 2) コンテナ起動（バックグラウンド）

```bash
docker run -d --name discord-chatgpt-bot \
  --env-file .env \
  -v "$PWD/settings.json:/app/settings.json" \
  --restart unless-stopped \
  discord-chatgpt-bot:1.0
```

### 3) 起動確認とログ

```bash
docker ps
docker logs -f discord-chatgpt-bot
```

ログに `ログイン成功` / `全コマンド登録完了` が出れば OK です

## 運用：停止・更新・自動起動

### 停止・再起動

```bash
docker stop discord-chatgpt-bot
docker start discord-chatgpt-bot
```

### 更新（コードを直したら）

コンテナは「作り直す」運用が基本なので、更新は次の流れになります

```bash
docker build -t discord-chatgpt-bot:1.1 .
docker stop discord-chatgpt-bot
docker rm discord-chatgpt-bot
docker run -d --name discord-chatgpt-bot \
  --env-file .env \
  -v "$PWD/settings.json:/app/settings.json" \
  --restart unless-stopped \
  discord-chatgpt-bot:1.1
```

### 自動起動（サーバ再起動対策）

今回の起動コマンドでは `--restart unless-stopped` を付けています  
これにより、サーバ再起動や Docker デーモン再起動後も、明示的に止めていない限り自動で復旧します

## まとめ

ターミナルでの手動起動をやめて Docker 化すると、「起動・停止・ログ・自動復旧」の運用が揃って管理がかなり楽になります  
さらに `.env`（秘密情報）と `settings.json`（永続化が必要な設定）をイメージから分離できるので、保守性と安全性が一段上がります
