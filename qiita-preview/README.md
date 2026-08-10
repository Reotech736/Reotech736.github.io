# Qiita Preview

Qiitaへ投稿する前に、生成済みのQiita用Markdownをブラウザで確認するための作業ディレクトリです。`README.md`とプレビュー専用の`qiita.config.json`だけをGit管理し、記事のコピーやキャッシュはGit管理しません。

## 前提

- リポジトリルートで`npm install`が完了している
- `npx qiita login`でローカルのQiita CLIへログインしている
- `ruby scripts/export-qiita.rb`で`qiita/public/`が生成されている

Qiitaのアクセストークンは、このディレクトリやリポジトリへ保存しないでください。Qiita CLIの認証情報は、通常`~/.config/qiita-cli/credentials.json`へ保存されます。

## プレビュー手順

リポジトリルートで、Qiita用ファイルをプレビューディレクトリへコピーします。

```bash
mkdir -p qiita-preview/public
rsync -a --delete qiita/public/ qiita-preview/public/
```

Qiita Previewを起動します。

```bash
npx qiita preview --root qiita-preview --config qiita-preview
```

プレビュー専用設定では`0.0.0.0:8888`で待ち受けます。起動後、接続元に応じたURLをブラウザで開きます。

```text
サーバー自身: http://localhost:8888
LAN:          http://192.168.2.94:8888
Tailscale:    http://100.78.247.106:8888
```

終了するときは、Qiita Previewを起動したターミナルで`Ctrl+C`を押します。

## UFWで接続元を限定する

`0.0.0.0`はLANとTailscaleの両方で待ち受けるため、プレビューを起動する前にネットワーク情報と既存のUFWルールを確認します。

```bash
ip -br -4 address
tailscale status
sudo ufw status numbered
```

LANは、接続元の`192.168.2.95`からサーバーの`192.168.2.94:8888`への通信だけを許可します。最初に`--dry-run`で内容を確認し、問題がなければ次のコマンドで反映します。

```bash
sudo ufw --dry-run allow in on enp2s0 proto tcp \
  from 192.168.2.95 to 192.168.2.94 port 8888 \
  comment 'Qiita Preview LAN'

sudo ufw allow in on enp2s0 proto tcp \
  from 192.168.2.95 to 192.168.2.94 port 8888 \
  comment 'Qiita Preview LAN'
```

Tailscaleは、`tailscale status`で確認したスマートフォンのIPv4アドレスだけを許可します。次の`100.x.x.x`を実際のスマートフォンのアドレスへ置き換えてください。

```bash
sudo ufw --dry-run allow in on tailscale0 proto tcp \
  from 100.x.x.x to 100.78.247.106 port 8888 \
  comment 'Qiita Preview Tailscale'

sudo ufw allow in on tailscale0 proto tcp \
  from 100.x.x.x to 100.78.247.106 port 8888 \
  comment 'Qiita Preview Tailscale'
```

既存ルールに`Anywhere on tailscale0 ALLOW IN Anywhere`のようなTailscaleインターフェース全体の許可がある場合、上のスマートフォン限定ルールを追加してもアクセス範囲は狭まりません。その既存ルールがSSHやほかのサービスで使われていないかを確認し、必要ならUFWの見直しとTailscaleのアクセス制御を別途行ってください。既存ルールは影響範囲を確認せずに削除しません。

反映後は、ルールと待ち受け状態を確認します。

```bash
sudo ufw status numbered
ss -ltnp | rg ':8888'
```

`sudo ufw allow 8888/tcp`のように接続元を限定しないルールは追加しません。また、SSH接続中にUFWが無効だった場合、既存のSSH許可ルールを確認せずに`sudo ufw enable`を実行しないでください。

## 確認項目

- タイトルとQiitaタグが意図どおりか
- 表、箇条書き、Mermaid、コードブロックが崩れていないか
- 画像とリンクが表示できるか
- ブログ内リンクが`https://reotech736.com/...`へ変換されているか
- 記事末尾に個人ブログの案内が追加されているか

## 記事を修正した場合

正本である`_posts/`の記事を修正し、Qiita用Markdownを再生成してからコピーし直します。

```bash
ruby scripts/export-qiita.rb
mkdir -p qiita-preview/public
rsync -a --delete qiita/public/ qiita-preview/public/
```

`qiita-preview/`内のMarkdownは直接編集しません。投稿対象としてGit管理するファイルは`qiita/public/`です。
