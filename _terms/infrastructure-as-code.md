---
title: "Infrastructure as Code"
slug: "infrastructure-as-code"
sort_key: "infrastructure-as-code"
summary: "インフラの構成と期待状態をコードで定義し、再現可能な形で管理する手法"
category: "aws"
aliases: ["IaC","インフラストラクチャ・アズ・コード"]
updated: 2026-07-16
---

## 一言でいうと
インフラの構成と期待状態をコードで定義し、再現可能な形で管理する手法。略称はIaC。

## より具体的には
Infrastructure as Codeでは、サーバ、ネットワーク、権限、クラウドサービスなどの構成を設定ファイルやプログラムで表現する。構成をバージョン管理し、レビューや自動化へ組み込むことで、手作業による設定漏れを減らし、同じ定義から環境を繰り返し構築できる。

IaCは、定義した構成の安全性や費用を自動的に保証するものではない。権限、秘密情報、変更時の影響、削除方法、料金を別途設計し、適用前後に確認する必要がある。

## 関連記事での使用例

### [初めてのIaCで学んだAWS CloudFormation](/2026/07/16/first-cloudformation-iac.html)
Linux監視環境のAMP workspaceとIAMユーザーを[AWS CloudFormation](/terms/aws-cloudformation/)のテンプレートで定義し、変更セットを確認してから作成した。

## 関連
- [AWS CloudFormation](/terms/aws-cloudformation/)
- [IAM](/terms/iam/)
