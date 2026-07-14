---
title: "Tailscale"
slug: "tailscale"
sort_key: "tailscale"
summary: "WireGuardを利用して端末間のプライベートネットワークを構成するサービス"
category: "network"
updated: 2026-07-14
---

## 一言でいうと
WireGuardを利用して端末間のプライベートネットワークを構成するサービス。

## より具体的には
端末を認証して仮想ネットワークへ参加させ、NAT越しでも相互接続しやすくする。管理画面やACLにより、どの端末や利用者がどこへ接続できるかを制御できる。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
友人がMinecraftサーバーの管理用SSHへ接続する経路を、公開インターネットから分離するため使用している。

## 関連
- [VPN](/terms/vpn/)
- [ACL](/terms/access-control-list/)
- [SSH](/terms/ssh/)
- [UFW](/terms/ufw/)
