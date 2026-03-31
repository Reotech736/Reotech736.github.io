---
title: "インターネットゲートウェイ"
slug: "internet-gateway"
sort_key: "いんたーねっとげーとうぇい"
summary: "VPCをインターネットに接続するためのゲートウェイ"
category: "aws"
aliases: ["Internet Gateway","internet gateway"]
updated: 2026-03-31
---

## 一言でいうと
VPCをインターネットに接続するためのゲートウェイ。

## より具体的には
インターネットゲートウェイは、VPC 内のリソースがインターネットと通信するために使う接続口。  
これ自体を VPC にアタッチし、さらにルートテーブル側でも経路設定を入れることで、パブリックサブネットから外部へ出られるようになる。

EC2 にパブリックIPを付けただけでは十分ではなく、VPC 側にインターネットゲートウェイと適切なルートが必要になる。  
そのため、外部公開する構成を学ぶ初期段階で重要になる。

## 関連
- [VPC](/terms/vpc/)
- [サブネット](/terms/subnet/)
- [ルートテーブル](/terms/route-table/)
- [EC2](/terms/ec2/)
