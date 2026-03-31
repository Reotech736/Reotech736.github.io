---
title: "VPC"
slug: "vpc"
sort_key: "vpc"
summary: "AWS上に作る仮想ネットワーク"
category: "aws"
updated: 2026-03-31
---

## 一言でいうと
AWS上に作る仮想ネットワーク。

## より具体的には
VPCは Virtual Private Cloud の略で、AWS 上に自分専用のネットワーク空間を作るための仕組み。  
IPアドレス範囲、サブネット、ルート、インターネット接続の有無などを設計できる。

EC2 や RDS などのリソースは、多くの場合この VPC の中で動かす。  
オンプレミスのネットワークをクラウド上に持ち込むイメージで考えると理解しやすい。

## 関連
- [サブネット](/terms/subnet/)
- [ルートテーブル](/terms/route-table/)
- [インターネットゲートウェイ](/terms/internet-gateway/)
- [セキュリティグループ](/terms/security-group/)
