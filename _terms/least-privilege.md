---
title: "最小権限"
slug: "least-privilege"
sort_key: "least-privilege"
summary: "利用者やプログラムへ必要最小限の権限だけを与える原則"
category: "security"
aliases: ["最小権限の原則","Principle of Least Privilege"]
updated: 2026-07-14
---

## 一言でいうと
利用者やプログラムへ必要最小限の権限だけを与える原則。

## より具体的には
業務や処理に不要な操作を許可せず、認証情報の漏えいや誤操作が起きた場合の影響範囲を抑える。権限は対象、操作、接続元、期間などの条件で絞り、定期的に見直す。

## 関連記事での使用例

### [Minecraft serverをDockerで安全運用する](/2026/03/02/minecraft-server-setup.html)
友人用ユーザーにゲームサーバーの必要な操作だけを委譲する設計原則として採用している。

## 関連
- [sudoers](/terms/sudoers/)
- [ACL](/terms/access-control-list/)
- [SSH公開鍵認証](/terms/ssh-public-key-authentication/)
