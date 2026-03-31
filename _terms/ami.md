---
title: "AMI"
slug: "ami"
summary: "EC2インスタンスを起動するための元となるマシンイメージ"
category: "aws"
updated: 2026-03-31
---

## 一言でいうと
EC2インスタンスを起動するための元となるマシンイメージ。

## より具体的には
AMIは Amazon Machine Image の略で、EC2インスタンスを作成するときに使用するテンプレート。  
OS、アプリケーション、ミドルウェア、設定情報などがあらかじめ含まれており、同じ構成のサーバーを繰り返し起動できる。

たとえば、Amazon Linux や Ubuntu などの基本OSが入ったAMIを使うこともできるし、  
自分で設定したEC2インスタンスから独自のAMIを作成して、同じ環境を複製することもできる。

AMIには主に以下のような情報が含まれる。

| 含まれるもの | 内容 |
| --- | --- |
| OS | Amazon Linux、Ubuntu、Windows Server など |
| ソフトウェア構成 | インストール済みのアプリケーションやミドルウェア |
| ストレージ設定 | ルートボリュームや追加ボリュームの構成 |
| 起動設定 | インスタンス起動時に必要な基本情報 |

EC2はAMIをもとに起動されるため、AMIは「サーバーのひな形」として使われることが多い。

## 関連
- [EC2](/terms/ec2/)
- [EBS](/terms/ebs/)
- <span class="pending-term" title="技術メモ準備中">Snapshot</span>
- <span class="pending-term" title="技術メモ準備中">Launch Template</span>
