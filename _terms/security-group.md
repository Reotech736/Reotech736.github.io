---
title: "セキュリティグループ"
slug: "security-group"
sort_key: "security-group"
summary: "AWSリソースに対する通信の許可ルールを管理する仮想ファイアウォール"
category: "aws"
aliases: ["Security Group","security group"]
updated: 2026-03-31
---

## 一言でいうと
AWSリソースに対する通信の許可ルールを管理する仮想ファイアウォール。

## より具体的には
セキュリティグループは、EC2 などのリソースに対して「どの通信を通してよいか」を定義する仕組み。  
たとえば、SSH の 22 番ポートは社内IPだけ許可し、Web の 80 番や 443 番は外部公開する、といった設定を行う。

基本的には許可ルールを書く方式で、拒否ルールを細かく並べるより「必要な通信だけ開ける」考え方になる。  
AWS のネットワーク設計ではかなり基本になる用語。

## 関連
- [EC2](/terms/ec2/)
- [VPC](/terms/vpc/)
- [サブネット](/terms/subnet/)
- [IAM](/terms/iam/)
