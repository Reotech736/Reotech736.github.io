---
title: "EC2"
slug: "ec2"
summary: "AWSで仮想サーバーを作成・利用できるサービス"
category: "aws"
updated: 2026-03-30
---

## 一言でいうと
AWSで仮想サーバーを作成・利用できるサービス。

## より具体的には
EC2は Amazon Elastic Compute Cloud の略で、AWS上で仮想マシンを立ち上げてアプリケーションを実行するためのサービス。  
インスタンスタイプを選ぶことで、CPU・メモリ・GPUなどの性能を用途に応じて決められる。  

| 用途 | インスタンスタイプ |
| --- | --- |
| 汎用 | T2、T3、M5 など |
| コンピューティング最適化 | C5、C4 など |
| メモリ最適化 | X1e、R4 など |
| 高速コンピューティング | P3、P2、F1 など |
| ストレージ最適化 | H1、I3、D2 など |

OS、ネットワーク、ストレージ、セキュリティ設定を組み合わせて、柔軟にサーバー環境を構築できる。

## 関連
- [EBS](/terms/ebs/)
- <span class="pending-term" title="技術メモ準備中">AMI</span>
- <span class="pending-term" title="技術メモ準備中">Security Group</span>
- <span class="pending-term" title="技術メモ準備中">IAM</span>
