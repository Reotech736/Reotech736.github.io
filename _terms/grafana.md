---
title: "Grafana"
slug: "grafana"
sort_key: "grafana"
summary: "メトリクスなどのデータをダッシュボードとグラフで可視化するツール"
category: "monitoring"
updated: 2026-07-14
---

## 一言でいうと
メトリクスなどのデータを、ダッシュボードとグラフで可視化するツール。

## より具体的には
Grafanaは、[Prometheus](/terms/prometheus/)などのデータソースへクエリを発行し、CPU使用率やメモリ使用率の推移をパネルとして表示する。現在値だけでなく、時間の経過に伴う変化や複数指標の関係を確認しやすい。

Linux Monitoring GPTでは、短い自然言語の状態確認をCustom GPT、詳細な時系列の確認をGrafanaと役割分担している。

## 関連
- [Prometheus](/terms/prometheus/)
- [PromQL](/terms/promql/)
- [Node Exporter](/terms/node-exporter/)
