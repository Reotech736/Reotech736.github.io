---
title: "authorized_keys"
slug: "authorized-keys"
sort_key: "authorized-keys"
summary: "SSH接続を許可する公開鍵と鍵ごとの制約を記録するファイル"
category: "security"
aliases: ["~/.ssh/authorized_keys"]
updated: 2026-07-14
---

## 一言でいうと
SSH接続を許可する公開鍵と、鍵ごとの制約を記録するファイル。

## より具体的には
ユーザーのSSH設定ディレクトリに置かれ、登録された公開鍵に対応する秘密鍵からの接続を許可する。鍵の行へcommandやrestrictなどのオプションを付け、実行可能な操作を制限できる。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
友人用の鍵に強制コマンドと接続機能の制限を設定するため使用している。

## 関連
- [SSH公開鍵認証](/terms/ssh-public-key-authentication/)
- [SSH](/terms/ssh/)
- [最小権限](/terms/least-privilege/)
