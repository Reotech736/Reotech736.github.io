---
layout: post
title: "Docker環境の構築"
date: 2026-01-21 00:00:00 +0900
author: Reo Komatsubara
tags: [Ubuntu, Docker]
---

## はじめに

Ubuntu に Docker をインストールして、コンテナを動かせる状態にするまでの手順をまとめます  
Docker を触るのが初めてでも理解しやすいように、まず用語（Docker / コンテナ / イメージ）をざっくり説明してから進めます  
<br>
この記事のゴールは「Docker 環境の構築」です（特定のアプリを Docker で動かす話ではありません）

## Dockerとは

Docker は、アプリを **「コンテナ」** という単位で動かすための仕組み（ツール群）です  
アプリの実行に必要なもの（ライブラリや設定など）をまとめて扱えるので、環境差分によるトラブルを減らしやすくなります

Docker を使うときの登場人物は大体この3つです

- **Docker Engine（デーモン）**: バックグラウンドで動いてコンテナを起動・停止する本体
- **Docker CLI**: `docker` コマンド（エンジンに指示するための操作口）
- **Docker Registry**: イメージの置き場（Docker Hub など）

## コンテナとは

コンテナは、ざっくり言うと **「隔離された実行環境」** です  
「別マシンのように見えるプロセス」を作って、その中でアプリを動かします

ポイントはここです

- コンテナは **VM（仮想マシン）ではない**（ホストOSのカーネルを共有して動く）
- その分、起動が速くて軽い
- ただし、コンテナの中で作ったデータは **基本的に消えやすい**（必要ならボリュームで永続化する）

## Docker Imageとは

Docker Image（イメージ）は、コンテナの元になる **「実行環境のテンプレート」** です  
イメージそのものは読み取り専用で、イメージから起動された実体がコンテナです

- **イメージ**: 料理のレシピ（テンプレート）
- **コンテナ**: できあがった料理（動いている実体）

イメージは手元で作る（`docker build`）こともできますし、配布されているものを取得（`docker pull`）して使うこともできます

## Dockerのインストール（Ubuntu 24.04 LTS）

今回は、公式のリポジトリ（`download.docker.com`）を追加して Docker Engine を入れます  
<br>
前提: `sudo` できるユーザーで作業します

### 1) 既存のDocker関連パッケージを削除（入っている場合）

```bash
sudo apt-get remove -y docker docker-engine docker.io containerd runc
```

### 2) 事前パッケージをインストール

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
```

### 3) Docker公式GPGキーの追加

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### 4) Docker公式リポジトリを追加

```bash
UBUNTU_CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" \
| sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### 5) Docker Engineをインストール

```bash
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

`docker-compose-plugin` まで入れているので、Compose は `docker compose ...` の形式で使えます

## 動作確認

### バージョン確認

```bash
docker --version
```

### hello-worldで確認

初回は権限の都合で `sudo docker ...` にしています

```bash
sudo docker run hello-world
```

`Hello from Docker!` が表示されれば OK です

### 実際にコンテナを起動してみる

次の例は、`ubuntu:24.04` イメージを取得して（初回はダウンロードされます）、その中で `bash` を起動します  
抜けるときは `exit` です

```bash
sudo docker run --rm -it ubuntu:24.04 bash
```

## （任意）sudoなしでdockerを使う（dockerグループ）

毎回 `sudo` を付けるのが面倒な場合は、ユーザーを `docker` グループに追加します

```bash
sudo usermod -aG docker "$USER"
```

追加後は、ログアウト→ログイン（または再起動）で反映されます  
すぐ試したい場合は一時的に `newgrp` でも OK です

```bash
newgrp docker
docker run --rm hello-world
```

※ `docker` グループは実質 root 権限相当の操作ができるため、共有マシンでは付与先に注意します

## 最低限覚えるDockerコマンド

環境構築後に「まず困らない」ための最小セットです

- イメージ一覧: `docker images`
- コンテナ一覧: `docker ps` / `docker ps -a`
- 起動: `docker run ...`
- 停止: `docker stop <name>`
- ログ: `docker logs -f <name>`
- コンテナ削除: `docker rm <name>`
- イメージ削除: `docker rmi <image>`
- Compose（プラグイン）: `docker compose version`

## つまずきポイント

### `permission denied` が出る

- `sudo docker ...` で実行する  
  または `docker` グループ追加後にログインし直してから `docker ...` を実行します

### `Cannot connect to the Docker daemon` が出る

Docker Engine が起動していない可能性があります

```bash
sudo systemctl enable --now docker
sudo systemctl status docker --no-pager
```

## まとめ

Ubuntu に Docker（Engine / Buildx / Compose）を入れて、コンテナを動かすところまで確認しました  
次は、適当なイメージ（例: `ubuntu:24.04`）を `docker run --rm -it ...` で動かして、コンテナの操作感に慣れるのがおすすめです
