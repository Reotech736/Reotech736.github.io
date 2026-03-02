---
layout: post
title: "Minecraft serverをDockerで安全運用する"
thumbnail: /assets/images/posts/2026-03-02-minecraft-server-setup/thumbnail.svg
date: 2026-03-02 00:00:00 +0900
author: Reo Komatsubara
tags: [Ubuntu, Docker, Minecraft]
---

## はじめに

[前回の記事「Docker環境の構築」]({% post_url 2026-01-21-docker-dev-setup %})で Docker を導入したので、今回はその上で **Minecraft Java サーバを2ワールド構成で運用**できるようにしました  
さらに、友人向けに SSH 操作を開放しつつ、サーバ全体に触れられないように **操作範囲を強制的に限定**しています

今回のゴールは次の3つです

- サバイバル/クリエイティブを Docker Compose で分離運用する
- 起動・停止・ログ管理をスクリプト化して保守しやすくする
- 友人用ユーザーに最小権限だけを渡し、誤操作や悪用時の被害を抑える

マインクラフトのサーバ構成は、[minecraft-server（GitHub）](https://github.com/Reotech736/minecraft-server) で管理しています

## 運用構成

- Ubuntu Server 上で Docker Compose を使用
- `mc-survival`（`25565`）と `mc-creative`（`25566`）を別コンテナで運用
- ワールドデータは `data-survival` / `data-creative` に分離して永続化
- 起動時にログ整理を自動判定するラッパースクリプトを利用
- 友人用ユーザー `guest-minecraft` は Tailscale 経由 SSH + 許可コマンドのみ実行

![minecraft server architecture](/assets/images/posts/2026-03-02-minecraft-server-setup/minecraft-server-architecture.svg)

## Docker Compose で2ワールドを分離

`docker-compose.yml` では、ポート・メモリ・ワールド保存先を分けています  
`restart: "no"` にしているのは、「遊ぶときだけ起動」の運用に合わせるためです

```yaml
services:
  mc-survival:
    image: itzg/minecraft-server:java21
    container_name: mc-survival
    ports:
      - "25565:25565"
    environment:
      MEMORY: "4G"
      ENABLE_WHITELIST: "TRUE"
    volumes:
      - ./data-survival:/data
    restart: "no"

  mc-creative:
    image: itzg/minecraft-server:java21
    container_name: mc-creative
    ports:
      - "25566:25565"
    environment:
      MEMORY: "2G"
      MODE: "creative"
      FORCE_GAMEMODE: "true"
    volumes:
      - ./data-creative:/data
    restart: "no"
```

## 日常運用はスクリプト化

起動・停止は次のスクリプトで統一しています

```bash
./scripts/start-minecraft.sh mc-survival
./scripts/start-minecraft.sh mc-creative
./scripts/stop-minecraft.sh mc-survival
./scripts/stop-minecraft.sh mc-creative
./scripts/stop-minecraft.sh
```

`start-minecraft.sh` は、前回ログ整理から24時間以上経っていたら `cleanup-minecraft-logs.sh` を実行し、30日超の圧縮ログ（`*.gz`）を削除します  
加えて、コンテナログ側も `max-size: 10m` / `max-file: 5` でローテーションしており、長期運用でディスクが詰まりにくい構成にしています

## 友人向け SSH は「実行できる操作」を固定

「SSH を渡す = 何でもできる」状態にしないため、入口を固定しました

1. 友人用ユーザー `guest-minecraft` を作成
2. パスワードログインを無効化し、公開鍵認証のみ許可
3. `authorized_keys` で `command="/usr/local/bin/mc-guest-entrypoint"` を強制
4. `mc-guest-entrypoint` で許可コマンドをホワイトリスト化
5. `sudoers` で `/usr/local/bin/mc-ctl` の限定サブコマンドだけ許可

`authorized_keys` 例:

```text
restrict,command="/usr/local/bin/mc-guest-entrypoint" ssh-ed25519 <public-key>
```

この1行は、次の意味です

- `ssh-ed25519 <public-key>`: この公開鍵で認証できる
- `command="/usr/local/bin/mc-guest-entrypoint"`: 鍵認証に成功したら、ユーザーが `ssh ... "任意コマンド"` を指定しても無視し、常にこのスクリプトを実行する
- `restrict`: `authorized_keys` 側の包括制限で、ポートフォワーディング（`-L/-R/-D`）、agent forward、X11 forward、PTY割り当て、`~/.ssh/rc` 実行を無効化する

つまり、接続時の実行フローは次のようになります

1. 公開鍵認証が通る
2. `mc-guest-entrypoint` が強制実行される
3. 元のコマンドは `SSH_ORIGINAL_COMMAND` としてスクリプト側で受け取り、ホワイトリスト判定
4. 許可コマンドのみ `sudo -n /usr/local/bin/mc-ctl ...` を実行
5. 不許可コマンドは即時拒否

`command=...` だけだと SSH 側のフォワーディング機能が残るため、今回のように `restrict` を併用して入口を狭める構成にしています

許可しているのは以下のみです

- `start survival`
- `start creative`
- `stop survival`
- `stop creative`
- `stop all`
- `status`

それ以外はサーバ側で拒否されます  
また、`guest-minecraft` を `docker` グループには入れていません（`docker` グループは実質 root 相当のため）

## 再現性を上げるための配置方針

`/usr/local/bin` や `/etc/sudoers.d` を直接手編集すると、差分管理が難しくなります  
そこで、正本はリポジトリ配下の `scripts/admin/` に置き、インストーラで反映する方式にしました

```bash
sudo ./scripts/admin/install-guest-minecraft.sh
```

主な管理対象:

- `scripts/admin/mc-ctl`
- `scripts/admin/mc-guest-entrypoint`
- `scripts/admin/guest-minecraft-mc.sudoers`
- `scripts/admin/install-guest-minecraft.sh`

## 友人側の操作導線（Windows）

友人向けには、`workspace/Guide_for_Friends/` に `.bat` と PowerShell UI を用意しました  
中身は最終的に `ssh guest-minecraft@<tailscale-ip> "<allowed-command>"` を叩くだけなので、実行範囲はサーバ側ポリシーで担保されます

## 「悪意ある相手でも安全か？」への整理

この構成は、**被害を小さくする設計**としては有効です  
ただし「絶対安全」ではありません 例えば次のリスクは残ります

- 鍵の漏えい（正規ユーザーとして接続される）
- 許可スクリプト自体のバグ
- ホスト OS / Docker / SSH の脆弱性

運用では、鍵ローテーション・OS更新・ログ監視を継続し、必要に応じて接続元制限（UFW + Tailscale ACL）を強化するのが現実的です

## まとめ

今回の構成で、Minecraft サーバ運用は次の状態になりました

- 2ワールドを明確に分離し、運用コマンドを統一
- ログ肥大化を自動で抑制
- 友人には「必要な操作だけ」委譲し、ホスト全体の露出を最小化

「動けばOK」で終わらせず、運用・保守・権限設計まで含めて形にできたのが一番の収穫でした
