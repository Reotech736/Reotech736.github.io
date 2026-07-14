---
title: "post-receiveフック"
slug: "post-receive-hook"
sort_key: "post-receive-hook"
summary: "Gitリポジトリがpushを受信した後に自動実行されるサーバー側フック"
category: "git"
aliases: ["post-receive hook","Git post-receive hook"]
updated: 2026-07-14
---

## 一言でいうと
Gitリポジトリがpushを受信した後に自動実行されるサーバー側フック。

## より具体的には
更新された参照の情報を受け取り、デプロイ、通知、変換処理などを起動できる。pushの成否や利用者へ影響するため、処理時間、失敗時のログ、権限を慎重に設計する必要がある。

## 関連記事での使用例

### [Obsidian & Discord-bot で個人用ナレッジベースを構築する](/2026/05/19/knowledge-base-pipeline.html)
knowledge-vaultへのpushを検知し、Linux側の作業リポジトリ更新とブログ用ファイルの生成を始めるため使用している。

## 関連
- [bareリポジトリ](/terms/bare-repository/)
- [Jekyll](/terms/jekyll/)
