---
title: Ubuntu開発環境の構築
tags:
  - Ubuntu
  - Linux
  - 開発環境
private: false
updated_at: '2026-08-09T15:15:53+09:00'
id: f190addafb53c2af46a3
organization_url_name: null
slide: false
ignorePublish: false
posting_campaign_uuid: null
agreed_posting_campaign_term: false
---

## はじめに

新たにNucBoxK12を購入したので、これまで使っていたNucBoxG5をLinuxサーバに回すことにしました。[WSL](https://reotech736.com/terms/wsl/)からおさらばして、ネイティブUbuntuで開発できる環境にします。ただ、せっかくのWindows 11 Proを消すのはもったいないので、[デュアルブート](https://reotech736.com/terms/dual-boot/)環境を構築します。今回選んだOSは Ubuntu 24.04.3 [LTS](https://reotech736.com/terms/long-term-support/) です。リリースから時間も経ち、そろそろ落ち着いてきた頃合いかなと思っています。

AWSに上げようか悩んでいたサービスも、今回はローカルで管理する方針にしました。WSL環境は定期的なWindows Updateの影響で保守が大変だったので、ローカルにLinuxサーバを構えて運用します。
以下は備忘録として、やったことを順にまとめます。

## Windows上での設定

### 簡易的なバックアップ

まずは重要データを外部SSDに退避しました。

### 高速スタートアップの無効化

コントロールパネルから高速スタートアップを無効化しました。

![高速スタートアップの無効化](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/windows-power-fast-startup.png)

### BitLockerの無効化

ドライブ暗号化機能の[BitLocker](https://reotech736.com/terms/bitlocker/)が有効だとトラブルになりやすいので、事前に無効化しました。

![BitLockerの無効化](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/windows-bitlocker-disabled.png)

### Ubuntu用の領域確保

ディスクの管理でCドライブを縮小し、Ubuntu用の未割り当て領域を作成しました。  
だいたい100GBほど確保できました。

**縮小操作の画面**
![ディスクの管理で縮小メニュー](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/windows-disk-management-shrink-menu.png)

**未割り当て領域の作成後**
![未割り当て領域の作成](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/windows-disk-management-unallocated.png)

## BIOS設定

設定は以下の通りです。

| 項目          | 設定       |
| ----------- | -------- |
| [Secure Boot](https://reotech736.com/terms/secure-boot/) | **OFF**  |
| SATA Mode   | **AHCI** |
| Boot Mode   | **[UEFI](https://reotech736.com/terms/uefi/)** |
| Fast Boot   | OFF      |
| VT-x / VT-d | ON       |

## インストールUSB作成

初期化してもよい8GB以上のUSBを用意しました。  
以下から必要なものを入手します。

- [Ubuntu Desktop 24.04.3 LTS](https://jp.ubuntu.com/download)
- [Rufus](https://apps.microsoft.com/detail/9PC3H3V7Q9CH?hl=ja-jp&gl=JP&ocid=pdpshare)

Rufusで以下を指定してUSBを作成しました。

- ISO: ubuntu-24.04.3-desktop-amd64.iso
- パーティション構成: GPT
- ターゲットシステム: UEFI (CSM 無効)

![Rufusの設定](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/rufus-ubuntu-usb.png)

## Ubuntuインストール

USBを挿した状態で起動し、インストーラを実行しました。  
先ほど作成した未割り当て領域を選んでUbuntuをインストールしています。パーティション構成を自身で考えるのにも慣れてきました。

## インストール後のセットアップ

インストール後は以下を設定しました。

- `openssh-server` のインストール
- IPアドレスの固定
  - これまでWSLのポートフォワーディングに頼っていたので、固定できるのは助かります
- リモートデスクトップの有効化
  - 環境を整えたものの、今のところ使う機会は少なそうです
- Sambaで共有フォルダの作成
  - ブログ用画像をWindows側で編集しやすくなりました
  - Sambaの構築は別記事にする予定です

![リモートデスクトップの有効化](https://reotech736.com/assets/images/posts/2026-01-18-ubuntu-dev-env/ubuntu-remote-desktop.png)

## まとめ

久々の構築でしたが、手順を整理しておくと次回が楽になります。  
また更新していきます。  
このLinux環境を使い倒して、スキルアップしていきますぞ～。

---

この記事は[Reo's Tech Blogの同名記事](https://reotech736.com/2026/01/18/ubuntu-dev-environment.html)にも掲載しています。

Reo's Tech Blogでは、個人開発や日々の技術的な取り組みを記録しています。興味がありましたら、[ほかの記事もご覧ください](https://reotech736.com/)。
