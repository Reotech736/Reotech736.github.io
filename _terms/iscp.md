---
title: "iSCP"
slug: "iscp"
sort_key: "iscp"
summary: "**iSCP** は、intdash でエッジデバイスとサーバー間のストリーミングデータを送受信するための、アプリケーション層の独自通信プロトコル。"
category: "network"
updated: 2026-05-27
---

## 一言でいうと
**iSCP** は、intdash でエッジデバイスとサーバー間のストリーミングデータを送受信するための、アプリケーション層の独自通信プロトコル。

## より具体的には
**iSCP** は、intdash でエッジデバイスとサーバー間のストリーミングデータを送受信するための、アプリケーション層の独自通信プロトコル。

より具体的には(md形式)
iSCP は **intdash Stream Control Protocol** の略で、aptpod/intdash が時系列データやセンサーデータ、映像などを扱うために利用するストリーミング用プロトコル。

TCP の一種ではなく、TCP より上位の **アプリケーション層プロトコル**にあたる。  
構造としては、概念的に次のような位置づけになる。

```text
iSCP
WebSocket / WebSocket Secure
TCP / TLS
IP
```

TCP はデータの到達順序や再送など、基本的な通信の信頼性を担う。  
一方で iSCP は、intdash の用途に合わせて、エッジデバイスとブローカー間のストリーミング制御、データ伝送、流量制御、欠損データの再送制御などを扱う。

そのため、HTTP、MQTT、WebSocket などと同じく、アプリケーションが目的に応じて使う通信プロトコルの一種として理解するとよい。

## 関連
- <span class="pending-term" title="技術メモ準備中">intdash</span>
- <span class="pending-term" title="技術メモ準備中">WebSocket</span>
- <span class="pending-term" title="技術メモ準備中">TCP</span>
- <span class="pending-term" title="技術メモ準備中">MQTT</span>
