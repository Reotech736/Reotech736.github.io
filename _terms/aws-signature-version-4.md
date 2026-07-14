---
title: "AWS Signature Version 4"
slug: "aws-signature-version-4"
sort_key: "aws-signature-version-4"
summary: "AWS APIリクエストの送信元と内容を検証するための署名方式"
category: "aws"
aliases: ["SigV4","AWS SigV4"]
updated: 2026-07-14
---

## 一言でいうと
AWS APIリクエストの送信元と内容を検証するための署名方式。略称はSigV4。

## より具体的には
SigV4は、AWS認証情報を使ってHTTPリクエストへ署名を付ける。AWS側は署名を検証し、署名した主体に許可されたIAM権限の範囲だけでリクエストを処理する。

Prometheus AgentからAMPへメトリクスを送る際にもSigV4を使う。HTTPSによる通信の暗号化とは別に、誰がどのAWS APIを呼び出せるかを[IAM](/terms/iam/)で制御する仕組みである。

## 関連
- [IAM](/terms/iam/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
