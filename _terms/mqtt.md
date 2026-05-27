---
title: "MQTT"
slug: "mqtt"
sort_key: "mqtt"
summary: "**MQTT** は、IoT機器やセンサーなどの軽量なデバイスが、低帯域・不安定なネットワークでもメッセージをやり取りしやすいように作られた通信プロトコル。"
category: "network"
updated: 2026-05-27
---

## 一言でいうと
**MQTT** は、IoT機器やセンサーなどの軽量なデバイスが、低帯域・不安定なネットワークでもメッセージをやり取りしやすいように作られた通信プロトコル。

## より具体的には
MQTT は **Message Queuing Telemetry Transport** の略で、主に IoT や M2M 通信で使われる軽量なメッセージングプロトコル。

TCP の一種ではなく、TCP の上で動く **アプリケーション層プロトコル**にあたる。  
構造としては、概念的に次のような位置づけになる。

```text
MQTT
TCP / TLS
IP
```

MQTT では、通信する端末同士が直接やり取りするのではなく、**Broker** と呼ばれる中継サーバーを介してメッセージを送受信する。

基本的な考え方は **Publish / Subscribe** 方式。

- **Publisher**: メッセージを送る側
- **Subscriber**: メッセージを受け取る側
- **Broker**: メッセージを中継するサーバー
- **Topic**: メッセージの宛先や分類を表す文字列

たとえば、温度センサーが次のような Topic にデータを Publish する。

```text
factory/line1/temperature
```

その Topic を Subscribe しているアプリケーションやサーバーが、温度データを受け取る。

MQTT は HTTP のように毎回リクエスト・レスポンスを行う方式ではなく、Broker との接続を維持しながら小さなメッセージを継続的に送受信する。そのため、IoT機器、センサーデータ収集、遠隔監視、車載・エッジデバイス連携などに向いている。

また、MQTT には QoS という配信保証レベルがある。

- **QoS 0**: 最大1回配信。届かない可能性があるが軽い
- **QoS 1**: 最低1回配信。重複する可能性はあるが届くことを重視
- **QoS 2**: 正確に1回配信。重いが重複を避けやすい

まとめると、MQTT は「軽量なデバイスが、Broker を介して Topic 単位でメッセージをやり取りするための通信プロトコル」と理解するとよい。

## 関連
- <span class="pending-term" title="技術メモ準備中">IoT</span>
- <span class="pending-term" title="技術メモ準備中">Broker</span>
- <span class="pending-term" title="技術メモ準備中">QoS</span>
- <span class="pending-term" title="技術メモ準備中">WebSocket</span>
- <span class="pending-term" title="技術メモ準備中">Kafka</span>
- <span class="pending-term" title="技術メモ準備中">Redis Streams</span>
