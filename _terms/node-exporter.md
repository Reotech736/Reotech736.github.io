---
title: "Node Exporter"
slug: "node-exporter"
sort_key: "node-exporter"
summary: "LinuxホストのCPUやメモリなどをPrometheus形式で公開するExporter"
category: "monitoring"
updated: 2026-07-14
---

## 一言でいうと
LinuxホストのCPU、メモリ、ディスク、ロードアベレージなどをPrometheus形式で公開するためのExporter。

## より具体的には
Node Exporterは、OSの状態を`/metrics`エンドポイントで公開する。[Prometheus](/terms/prometheus/)やPrometheus Agentがこのエンドポイントを定期的に取得することで、ホストの状態を時系列データとして保存できる。

Exporter自身は長期保存やクラウドへの転送を担当しない。公開範囲を抑えるため、自宅サーバでは`127.0.0.1`だけで待ち受け、同じホスト上のAgentから取得する構成にしている。

## 関連
- [Prometheus](/terms/prometheus/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
- [Grafana](/terms/grafana/)
