---
title: "再起動ポリシー"
slug: "restart-policy"
sort_key: "restart-policy"
summary: "コンテナ停止後にDockerが再起動する条件を定める設定"
category: "container"
aliases: ["Restart Policy","Docker restart policy"]
updated: 2026-07-14
---

## 一言でいうと
コンテナ停止後にDockerが再起動する条件を定める設定。

## より具体的には
終了状態やDockerデーモンの再起動に応じて、自動復旧させるかを制御する。常駐サービスの可用性を高められる一方、意図的な停止や繰り返す異常終了を考慮して選ぶ必要がある。

## 関連記事での使用例

### [Discord Bot を Docker で常駐運用する](/2026/01/26/discord-chatgpt-bot-docker.html)
unless-stoppedを指定し、サーバー再起動後もBotを自動復旧させている。

## 関連
- [Docker](/terms/docker/)
- [Docker Engine](/terms/docker-engine/)
