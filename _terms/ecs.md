---
title: "ECS"
slug: "ecs"
sort_key: "ecs"
summary: "AWSでコンテナを実行・管理できるサービス"
category: "aws"
updated: 2026-03-31
---

## 一言でいうと
AWSでコンテナを実行・管理できるサービス。

## より具体的には
ECSは Amazon Elastic Container Service の略で、Docker などのコンテナを AWS 上で動かすためのサービス。  
Kubernetes を直接扱わずに、AWS 流のシンプルな形でコンテナを運用したいときによく使われる。

コンテナの定義、起動台数、ネットワーク設定、ログ収集などを組み合わせて、アプリケーションを継続的に動かせる。  
実行基盤として EC2 を使うことも、サーバーレス実行基盤の Fargate を使うこともできる。

## 関連
- [EKS](/terms/eks/)
- [EC2](/terms/ec2/)
- [IAM](/terms/iam/)
- [セキュリティグループ](/terms/security-group/)
