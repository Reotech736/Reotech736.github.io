---
title: "PromQL"
slug: "promql"
sort_key: "promql"
summary: "Prometheusのメトリクスを検索・集計するためのクエリ言語"
category: "monitoring"
aliases: ["Prometheus Query Language"]
updated: 2026-07-14
---

## 一言でいうと
Prometheusに保存されたメトリクスを検索・集計するためのクエリ言語。

## より具体的には
PromQLは、メトリクス名やラベルを指定して、現在値や一定期間の変化量を取得する。たとえば`up`は監視対象へ到達できているかを、CPUのidle時間から計算する式はCPU使用率を確認するために使える。

柔軟に分析できる反面、任意のクエリを外部入力として受け付けると、意図しない高負荷な照会や不要な情報の取得につながる。Linux Monitoring GPTでは、API側で定義した固定クエリだけを実行する。

## 関連
- [Prometheus](/terms/prometheus/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
- [Grafana](/terms/grafana/)
