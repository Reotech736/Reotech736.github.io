---
title: "サブネット"
slug: "subnet"
sort_key: "subnet"
summary: "VPCの中を用途ごとに分割したネットワーク範囲"
category: "aws"
aliases: ["Subnet","subnet"]
updated: 2026-03-31
---

## 一言でいうと
VPCの中を用途ごとに分割したネットワーク範囲。

## より具体的には
サブネットは VPC をさらに小さく分けたネットワーク単位。  
たとえば、外部公開する Web サーバー用のパブリックサブネットと、外部から直接見せない DB 用のプライベートサブネットを分ける、といった設計に使う。

どのサブネットに配置するかによって、外部インターネットへ直接出られるか、どの経路を通るかが変わる。  
AWS のネットワーク設計では、VPC とセットで理解する基本用語。

## 関連
- [VPC](/terms/vpc/)
- [ルートテーブル](/terms/route-table/)
- [インターネットゲートウェイ](/terms/internet-gateway/)
- [EC2](/terms/ec2/)
