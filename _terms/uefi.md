---
title: "UEFI"
slug: "uefi"
sort_key: "uefi"
summary: "OS起動前のハードウェア初期化と起動処理を担うファームウェア仕様"
category: "os"
aliases: ["Unified Extensible Firmware Interface"]
updated: 2026-07-14
---

## 一言でいうと
OS起動前のハードウェア初期化と起動処理を担うファームウェア仕様。

## より具体的には
従来のBIOSを置き換える仕組みで、EFIシステムパーティションにあるブートローダーを読み込む。Secure Bootや大容量ディスクへの対応など、現代のPCでOSを起動する基盤になる。

## 関連記事での使用例

### [Ubuntu開発環境の構築](/2026/01/18/ubuntu-dev-environment.html)
USBからUbuntuを起動し、Windowsとのデュアルブートを構成する際の起動基盤として扱っている。

## 関連
- [Secure Boot](/terms/secure-boot/)
- [デュアルブート](/terms/dual-boot/)
- [ファームウェア](/terms/firmware/)
