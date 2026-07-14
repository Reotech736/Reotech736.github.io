---
title: "SSH公開鍵認証"
slug: "ssh-public-key-authentication"
sort_key: "ssh-public-key-authentication"
summary: "秘密鍵の所持を確認してSSH利用者を認証する方式"
category: "security"
aliases: ["Public Key Authentication","公開鍵認証"]
updated: 2026-07-14
---

## 一言でいうと
秘密鍵の所持を確認してSSH利用者を認証する方式。

## より具体的には
サーバーへ公開鍵を登録し、接続時には対応する秘密鍵で署名できることを検証する。十分に保護された鍵を使えばパスワード総当たりを避けられるが、秘密鍵の保管と失効運用が重要になる。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
友人用アカウントへのSSH接続を鍵認証だけに限定するため使用している。

## 関連
- [SSH](/terms/ssh/)
- [authorized_keys](/terms/authorized-keys/)
- [最小権限](/terms/least-privilege/)
