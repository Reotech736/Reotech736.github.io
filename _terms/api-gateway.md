---
title: "API Gateway"
slug: "api-gateway"
sort_key: "api-gateway"
summary: "HTTP APIの公開、認証、バックエンド連携を管理するAWSサービス"
category: "aws"
aliases: ["Amazon API Gateway"]
updated: 2026-07-14
---

## 一言でいうと
HTTP APIの公開、認証、バックエンド連携を管理するAWSサービス。

## より具体的には
API Gatewayは、クライアントからのHTTPリクエストを受け取り、認証やルーティングを行ってバックエンドへ渡す。URL、HTTPメソッド、認証方式、アクセス制御を入口で管理でき、バックエンドにはLambdaや別のHTTPサービスを接続できる。

## 関連記事での使用例

### [Custom GPTでLinuxサーバを診断する](/2026/07/14/linux-monitoring-gpt.html)
`GET /hosts/home-server/status`だけを公開し、[Cognito OAuth](/terms/cognito-oauth/)のアクセストークンを検証してから[AWS Lambda](/terms/aws-lambda/)へリクエストを渡す。

## 関連
- [AWS Lambda](/terms/aws-lambda/)
- [Cognito OAuth](/terms/cognito-oauth/)
- [Custom GPT Actions](/terms/custom-gpt-actions/)
