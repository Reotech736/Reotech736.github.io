---
title: "Autodesk FusionをCodexとMCP連携して立方体を作る"
tags:
  - "AutodeskFusion"
  - "MCP"
  - "ChatGPT"
  - "Codex"
  - "3DCAD"
private: false
updated_at: "2026-11-06T23:57:16+09:00"
id: "18a3421ffd4626f8d0bc"
organization_url_name: null
slide: false
ignorePublish: false
posting_campaign_uuid: null
agreed_posting_campaign_term: false
---

Autodesk Fusion（個人用）をChatGPTのCodexと連携し、会話から3Dモデルを操作できる環境を試しました。今回はFusionがローカルで公開するMCPサーバーへCodexを接続し、10 mm角の立方体を作成して寸法を読み取るところまで確認します。

## 今回確認した構成

Autodesk Fusionには、起動中のデスクトップアプリをAIクライアントから操作するためのローカルMCPサーバーがあります。Fusionが同じPC上でMCPのエンドポイントを公開し、CodexがHTTPで接続する構成です。

```text
Codex
  └─ HTTP（MCP）
       └─ http://127.0.0.1:27182/mcp
            └─ Autodesk Fusion（デスクトップアプリ）
```

今回使った環境はAutodesk Fusionの個人用ライセンスです。画面や項目名は、FusionとCodexの更新によって変わる可能性があります。

## Fusion MCPサーバーを有効にする

Fusionを起動し、右上のプロフィールアイコンから「基本設定」を開きます。

![Autodesk Fusionのプロフィールメニューから基本設定を開く](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/fusion-profile-menu.png)

左側の一覧から「一般 > API」へ進み、「Fusion MCP サーバ（このデバイス上でローカルに実行されます）」を有効にします。ポートは既定値の`27182`を使いました。

![Autodesk Fusionの基本設定でFusion MCPサーバーを有効にした画面](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/fusion-mcp-settings.png)

有効にすると、接続先は次のURLになります。

```text
http://127.0.0.1:27182/mcp
```

Autodeskの[公式接続ガイド](https://help.autodesk.com/cloudhelp/ENU/ADSKMCP-FusionDesktopMcp/files/ADSKMCP_FusionDesktopMcp_connecting_to_the_fusion_mcp_server_html.html)でも、既定の接続先として同じURLが案内されています。ポートを変更した場合は、Codex側のURLも同じ番号へ変更します。

このMCPサーバーはFusionのプロセス内で動くため、利用中はFusionを起動したままにします。接続先はインターネットへ公開せず、`127.0.0.1`で待ち受けます。

## Codexへ接続先を登録する

Codexへ`autodesk-fusion`という名前でMCPサーバーを登録します。Codex CLIを使う場合は、次のコマンドでHTTP接続先を追加できます。

```bash
codex mcp add autodesk-fusion --url http://127.0.0.1:27182/mcp
```

登録結果は次のコマンドで確認します。

```bash
codex mcp list
```

CodexのMCP設定はCLIとアプリで共有されます。登録後に接続が反映されない場合は、Codexアプリを再起動します。Fusionは起動したままで構いません。

![CodexがFusionへの接続を確認し、アプリの再起動を案内している画面](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/codex-connected.png)

今回の確認では、最初に既定ポートへ接続できない状態がありました。Fusionの「一般 > API」にMCPサーバーの項目が表示され、有効になっていることを確認してから再接続しています。

![CodexがFusion側のMCP設定を確認するよう案内している画面](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/codex-setup-guidance.png)

## 10 mm角の立方体を作る

接続後、Fusionで新規デザインを開き、Codexへ10 mm角の立方体を作るよう依頼しました。CodexがFusionのツールを呼び出し、`AI_connection_test`というデザインに立方体を作成しました。

![Codexが10 mm角の立方体を作成し、寸法と体積を確認した結果](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/codex-cube-result.png)

Codexが読み取った結果は次のとおりです。

| 項目 | 結果 |
| --- | ---: |
| 寸法 | 10 × 10 × 10 mm |
| 体積 | 1,000 mm³ |
| ボディ数 | 1個 |

Fusionの画面にも立方体が作成され、ブラウザには1個のボディとスケッチが追加されていました。

![Autodesk Fusion上に作成された10 mm角の立方体](https://reotech736.com/assets/images/posts/autodesk-fusion-codex-mcp/fusion-cube-created.png)

今回は作成結果を保存せず、未保存のテスト用デザインとして確認しました。Codexから形状を作るだけでなく、作成後の寸法、体積、ボディ数も読み取れたため、Fusionとの双方向の操作を確認できました。

## 試して分かった注意点

### Fusionを先に起動する

ローカルMCPサーバーはFusionが起動している間だけ利用できます。Codexから接続する前にFusionを起動し、MCPサーバーが有効になっていることを確認します。

### 設計データを開いてから操作する

形状を作るときは、Fusionで操作対象のデザインを開いておきます。既存の設計を扱う場合は、AIへ依頼する前に対象のドキュメントが正しいかを画面で確認したほうが安全です。

### 変更内容を画面で確認する

MCP経由のツールには形状を変更する操作が含まれます。最初は未保存の新規デザインで試し、作成された形状や寸法をFusion側でも確認します。既存データを扱う場合は、保存や変更の範囲を依頼文で明示する予定です。

## 動作確認の結果

Autodesk FusionのローカルMCPサーバーを有効にし、Codexから接続できました。動作確認では10 mm角の立方体を作成し、寸法、体積、ボディ数を読み取っています。

今回は単純な形状だけですが、自然文からFusionを操作するための最小構成を確認できました。次は寸法を指定した部品の作成や、既存モデルの情報取得を試していきます。

---

この記事は[Reo's Tech Blogの同名記事](https://reotech736.com/2026/11/06/autodesk-fusion-codex-mcp.html)にも掲載しています。

Reo's Tech Blogでは、個人開発や日々の技術的な取り組みを記録しています。興味がありましたら、[ほかの記事もご覧ください](https://reotech736.com/)。
