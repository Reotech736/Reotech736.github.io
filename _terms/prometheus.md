---
title: "Prometheus"
slug: "prometheus"
sort_key: "prometheus"
summary: "メトリクスを収集・保存し、PromQLで状態を確認するための監視システム"
category: "monitoring"
updated: 2026-07-14
---

## 一言でいうと
メトリクスを一定間隔で収集・保存し、サーバやアプリケーションの状態を確認するための監視システム。

## より具体的には
Prometheusは、CPU使用率やメモリ使用量のような数値を時系列データとして扱う。多くの場合はExporterと呼ばれるプログラムが公開するメトリクスを定期的に取得し、必要に応じてグラフ化やアラートに利用する。

データの検索や集計には[PromQL](/terms/promql/)を使う。自宅サーバの監視では、[Node Exporter](/terms/node-exporter/)からホストのメトリクスを取得し、ローカル表示用のPrometheusと、AMPへ送信するPrometheus Agentを使い分けている。

## 関連
- [Node Exporter](/terms/node-exporter/)
- [PromQL](/terms/promql/)
- [Grafana](/terms/grafana/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
