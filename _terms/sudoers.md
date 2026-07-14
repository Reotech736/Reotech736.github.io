---
title: "sudoers"
slug: "sudoers"
sort_key: "sudoers"
summary: "sudoで誰がどの権限で何を実行できるかを定義する設定"
category: "security"
aliases: ["sudoers設定"]
updated: 2026-07-14
---

## 一言でいうと
sudoで誰がどの権限で何を実行できるかを定義する設定。

## より具体的には
ユーザーやグループ、実行可能なコマンド、実行先ユーザー、パスワード要否などを規則として記述する。誤設定は権限昇格につながるため、visudoによる構文確認と限定的な許可が重要になる。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
友人用ユーザーにMinecraft管理スクリプトの限定コマンドだけを許可するため使用している。

## 関連
- [最小権限](/terms/least-privilege/)
- [ACL](/terms/access-control-list/)
- [SSH公開鍵認証](/terms/ssh-public-key-authentication/)
