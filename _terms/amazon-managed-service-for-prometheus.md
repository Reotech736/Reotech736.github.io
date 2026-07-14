---
title: "Amazon Managed Service for Prometheus"
slug: "amazon-managed-service-for-prometheus"
sort_key: "amazon-managed-service-for-prometheus"
summary: "AWSが提供するマネージドなPrometheus互換のメトリクス保存・照会サービス"
category: "aws"
aliases: ["AMP"]
updated: 2026-07-14
---

## 一言でいうと
AWSが運用する、Prometheus互換のメトリクス保存・照会サービス。略称はAMP。

## より具体的には
AMPは、Prometheus形式のメトリクスを`remote_write`で受け取り、PromQL互換のAPIで照会できる。自前で長期保存用Prometheusを公開・運用せずに、メトリクスをAWS側へ保持したいときに使える。

自宅Linuxサーバの監視では、Prometheus AgentがHTTPSと[AWS Signature Version 4](/terms/aws-signature-version-4/)で署名したリクエストをAMPへ送る。診断APIは固定した[PromQL](/terms/promql/)でAMPを照会し、Custom GPTへ必要な状態だけを返す。

## 関連
- [Prometheus](/terms/prometheus/)
- [PromQL](/terms/promql/)
- [AWS Signature Version 4](/terms/aws-signature-version-4/)
- [IAM](/terms/iam/)
