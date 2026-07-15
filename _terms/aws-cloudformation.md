---
title: "AWS CloudFormation"
slug: "aws-cloudformation"
sort_key: "aws-cloudformation"
summary: "テンプレートからAWSリソースを作成し、スタック単位で管理するIaCサービス"
category: "aws"
aliases: ["CloudFormation"]
updated: 2026-07-16
---

## 一言でいうと
テンプレートからAWSリソースを作成し、スタック単位で管理するInfrastructure as Codeサービス。

## より具体的には
AWS CloudFormationでは、YAMLまたはJSONのテンプレートに、必要なAWSリソース、設定、依存関係を宣言する。CloudFormationはテンプレートを基にリソースを作成し、関連するリソースをスタックとしてまとめて更新・削除する。

変更セットを使うと、スタックへ適用する予定の追加、変更、削除を実行前に確認できる。CloudFormation管理外で加えられた変更はドリフト検出で確認できるが、変更セットや事前検証だけで実行時の成功や構成の安全性が保証されるわけではない。

## 関連記事での使用例

### [初めてのIaCで学んだAWS CloudFormation](/2026/07/16/first-cloudformation-iac.html)
AMP workspaceと書き込み専用IAMユーザーを一つのテンプレートで定義し、変更セットで対象リソースを確認してからスタックを作成した。

## 関連
- [Infrastructure as Code](/terms/infrastructure-as-code/)
- [IAM](/terms/iam/)
- [Amazon Managed Service for Prometheus](/terms/amazon-managed-service-for-prometheus/)
