---
title: "AWS Lambda"
slug: "aws-lambda"
sort_key: "aws-lambda"
summary: "サーバーを常時管理せず、イベントに応じてコードを実行できるAWSサービス"
category: "aws"
aliases: ["Lambda"]
updated: 2026-07-14
---

## 一言でいうと
サーバーを常時管理せず、イベントに応じてコードを実行できるAWSサービス。

## より具体的には
Lambdaは、HTTPリクエストやAWSサービスのイベントをきっかけに関数を実行する。実行基盤のOSやサーバープロセスを自分で管理せず、処理に必要なコードと権限を定義する。

Linux Monitoring GPTでは、[API Gateway](/terms/api-gateway/)から呼び出され、固定した[PromQL](/terms/promql/)でAMPを照会して診断結果のJSONを返す。実行ロールには、必要なAMP照会権限だけを与える。

## 関連
- [API Gateway](/terms/api-gateway/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
- [IAM](/terms/iam/)
