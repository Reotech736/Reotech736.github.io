---
layout: post
title: "Ubuntuの特定ディレクトリをWindowsエクスプローラーで開く（Samba/SMB）"
date: 2026-01-18 02:30:00 +0900
author: Reo Komatsubara
tags: [Ubuntu, Samba, Windows]
---

## はじめに

家庭内LANに置いたUbuntu（Linuxサーバ）の特定ディレクトリを、**Windowsのエクスプローラー**から `\\IPaddr\share` の形式で開いて**読み書きできる**ようにします

想定している構成は以下です

- Ubuntu（サーバ）IP: `192.168.2.94`（固定）
- Windows（クライアント）IP: `192.168.2.95`（固定）
- 共有したいディレクトリ: `/home/relion911`

![Samba共有の構成図](/assets/images/posts/2026-01-18-samba-windows-share/samba-share-diagram.svg)

## なぜ Samba（SMB）なのか

WindowsからLinuxのファイルを扱う方法はいくつかありますが、今回は**Samba（SMB）**を選びました

### Sambaのメリット

- **Windowsが標準で対応**していて、追加ソフト不要
- エクスプローラーから普段のフォルダと同じ感覚で扱える
- 家庭内LANの範囲なら導入と運用が**シンプル**

SFTPマウントも選択肢ですが、Windows側に追加ツールが必要だったり、操作感が重く感じることがありました
**「Windowsのエクスプローラーで普通に開ければ十分」**という用途ならSambaが最短です

## 導入手順（Ubuntu側）

### 1) Sambaをインストール

```bash
sudo apt update
sudo apt install -y samba
```

### 2) 共有するディレクトリを決める

今回は**ホームディレクトリ**を共有します

- 共有対象: `/home/relion911`

別ディレクトリを共有する場合は、後述の `path` を変更するだけです

### 3) Sambaユーザーを作成

Linuxユーザーに紐づけて**Samba用のパスワード**を設定します

```bash
sudo smbpasswd -a relion911
sudo smbpasswd -e relion911
```

Ubuntuのログインパスワードと同じでも別でもOKです

### 4) 共有設定（/etc/samba/smb.conf）

バックアップを取ってから編集します

```bash
sudo cp -a /etc/samba/smb.conf /etc/samba/smb.conf.bak.$(date +%F_%H%M%S)
sudoedit /etc/samba/smb.conf
```

末尾に追記します（**共有名は `share` の例**）

```ini
[share]
   path = /home/relion911
   browseable = yes
   read only = no
   guest ok = no
   valid users = relion911
   create mask = 0660
   directory mask = 2770
```

#### （任意）所有者のブレを抑える

Windowsから作成したファイルの所有者が揃わず困る場合は**追加**します

```ini
   force user = relion911
   force group = relion911
```

### 5) 設定チェック → Samba再起動

```bash
sudo testparm
sudo systemctl restart smbd nmbd
sudo systemctl enable --now smbd nmbd
```

### 6) UFWで接続元をWindowsだけに絞る（推奨）

家庭内でも共有を開きっぱなしにするなら、**アクセス元を絞る**のが安全です

```bash
sudo ufw allow from 192.168.2.95 to any app Samba
sudo ufw status
```

以前に `sudo ufw allow samba` のように広く許可していた場合は、`sudo ufw status numbered` で確認して不要ルールを削除します

## Windows側の使い方（エクスプローラー）

### 1) 共有を開く

エクスプローラーのアドレスバーに**入力**します

- `\\192.168.2.94\share`

資格情報を求められたら、以下で**ログイン**します

- ユーザー名: `relion911`
- パスワード: `smbpasswd` で設定したもの

![WindowsエクスプローラーからSamba共有へアクセス](/assets/images/posts/2026-01-18-samba-windows-share/windows-explorer-share.png)

### 2) ネットワークドライブに割り当て（便利）

エクスプローラー → 「PC」 → 「ネットワークドライブの割り当て」

- ドライブ例: `Z:`
- フォルダ: `\\192.168.2.94\share`

## 動作確認（Ubuntu側）

### 共有設定が効いているか

```bash
testparm -sv | sed -n '/\[share\]/,/^\[/{p}'
```

`read only = No` ならWindowsからの**編集・上書きが反映**されます

### SMBポートが待ち受けているか

```bash
sudo ss -lntp | egrep ':(445|139)\b' || echo "SMB not listening"
```

## よくあるハマりどころ

### 1) ドットファイルが見えない

Windows側で「隠しファイルを表示」がOFFだと `.ssh` などが**見えません**
エクスプローラーの「表示」メニューから隠しファイルをONにします

Samba側で隠している場合は `hide dot files` などの設定が影響していることがあります

### 2) `.ssh` 配下の編集は注意

SSHは権限に厳しいため、Windows側の編集でパーミッションが変わると**ログインできなくなる**ことがあります
`.ssh` 配下はUbuntu側で**編集する運用が安全**です

### 3) セキュリティ

Samba共有は便利な反面、開放範囲が広いと**リスクが上がります**

- **UFWで特定IPだけ許可**
- **インターネットへ直接公開しない**
- 必要ならVPN経由でアクセス

## まとめ

- WindowsエクスプローラーからLinuxのディレクトリを扱うなら、**Samba（SMB）が最短で導入できる**
- Ubuntu側で共有設定を入れ、Windows側は `\\IPaddr\share` でアクセスする
- **UFWで接続元を絞る**と家庭内運用でも安全性が上がる
