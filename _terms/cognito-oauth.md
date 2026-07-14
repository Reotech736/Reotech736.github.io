---
title: "Cognito OAuth"
slug: "cognito-oauth"
sort_key: "cognito-oauth"
summary: "Amazon Cognitoを使い、OAuth 2.0で利用者ごとにAPI利用を認証する構成"
category: "aws"
aliases: ["Cognito","OAuth 2.0"]
updated: 2026-07-14
---

## 一言でいうと
Amazon Cognitoを使い、OAuth 2.0で利用者ごとにAPIの利用を認証する構成。

## より具体的には
OAuth 2.0では、利用者が認可サーバーへサインインして取得したアクセストークンを使い、クライアントがAPIを呼び出す。共有APIキーと異なり、誰が利用しているかを利用者単位で扱える。

Amazon Cognitoは、ユーザー管理とOAuthの認可エンドポイントを提供するAWSサービス。クライアント、API Gateway、アプリケーションがそれぞれトークンを検証することで、認証とアクセス制御を分担できる。

## 関連記事での使用例

### [Custom GPTでLinuxサーバを診断する](/2026/07/14/linux-monitoring-gpt.html)
Custom GPT ActionsがCognitoへサインインし、API GatewayとLambdaがトークンのスコープとグループを確認する。

## 関連
- [API Gateway](/terms/api-gateway/)
- [AWS Lambda](/terms/aws-lambda/)
- [IAM](/terms/iam/)
