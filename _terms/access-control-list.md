---
title: "ACL"
slug: "access-control-list"
sort_key: "access-control-list"
summary: "主体ごとに許可または拒否する操作を列挙したアクセス制御規則"
category: "security"
aliases: ["Access Control List","アクセス制御リスト"]
updated: 2026-07-14
---

## 一言でいうと
利用者や端末などの主体ごとに、許可または拒否する操作を列挙したアクセス制御規則。

## より具体的には
ネットワーク通信、ファイル操作、サービス利用などの対象に対し、誰が何をできるかを定義する。規則が増えると把握しにくくなるため、最小権限と明確な優先順位が重要になる。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
Tailscale上で接続元とMinecraftサーバーへの到達可否を制限するため使用している。

## 関連
- [最小権限](/terms/least-privilege/)
- [Tailscale](/terms/tailscale/)
- [UFW](/terms/ufw/)
- [sudoers](/terms/sudoers/)
