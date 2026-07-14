---
title: "UFW"
slug: "ufw"
sort_key: "ufw"
summary: "Linuxのファイアウォール設定を簡潔なコマンドで管理するツール"
category: "security"
aliases: ["Uncomplicated Firewall"]
updated: 2026-07-14
---

## 一言でいうと
Linuxのファイアウォール設定を簡潔なコマンドで管理するツール。

## より具体的には
内部ではnetfilterを利用し、ポート番号、プロトコル、接続元などを条件に通信を許可または拒否する。必要な通信だけを明示的に開放することで、サーバーの公開範囲を抑えられる。

## 関連記事での使用例

### [Ubuntuの特定ディレクトリをWindowsエクスプローラーで開く（Samba/SMB）](/2026/01/18/samba-windows-share.html)
家庭内LANからのSMB通信だけを許可するために使用している。

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
ゲームサーバーや管理用通信の到達範囲を制限する防御策として使用している。

## 関連
- [Samba](/terms/samba/)
- [VPN](/terms/vpn/)
- [SSH](/terms/ssh/)
