---
title: "Custom GPT Actions"
slug: "custom-gpt-actions"
sort_key: "custom-gpt-actions"
summary: "Custom GPTからOpenAPIで定義した外部HTTP APIを呼び出す機能"
category: "ai"
aliases: ["GPT Actions","Actions"]
updated: 2026-07-14
---

## 一言でいうと
Custom GPTから、OpenAPIで定義した外部HTTP APIを呼び出す機能。

## より具体的には
Actionsでは、APIのエンドポイント、入力、応答、認証方式をOpenAPIスキーマとして登録する。GPTはInstructionsとスキーマに基づいて、必要なときにAPIを呼び出し、その結果を会話の回答へ反映する。

外部APIの公開範囲と認証方式は、Actionごとに設計する必要がある。必要な操作だけを小さなAPIとして公開すると、GPTに渡す権限を絞りやすい。

## 関連記事での使用例

### [Custom GPTでLinuxサーバを診断する](/2026/07/14/linux-monitoring-gpt.html)
Linux Monitoring GPTでは、状態確認専用のAPIをActionとして登録している。MCPサーバを使う構成ではなく、読み取り専用のHTTP APIと[Cognito OAuth](/terms/cognito-oauth/)を組み合わせている。

## 関連
- [API Gateway](/terms/api-gateway/)
- [Cognito OAuth](/terms/cognito-oauth/)
- [AWS Lambda](/terms/aws-lambda/)
