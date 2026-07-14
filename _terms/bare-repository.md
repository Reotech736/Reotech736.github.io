---
title: "bareリポジトリ"
slug: "bare-repository"
sort_key: "bare-repository"
summary: "作業ツリーを持たずGitの履歴と参照だけを保存するリポジトリ"
category: "git"
aliases: ["Bare Repository","ベアリポジトリ"]
updated: 2026-07-15
---

## 一言でいうと
作業ツリーを持たず、Gitの履歴と参照だけを保存するリポジトリ。

## より具体的には
通常の編集用ファイルを展開せず、他のリポジトリからpushやfetchされる中央の受け皿として利用する。サーバー上の共有リポジトリや、pushを起点とした自動処理に向いている。

## 関連記事での使用例

### [Obsidian & Discord-bot で個人用ナレッジベースを構築する](/2026/05/19/knowledge-base-pipeline.html)
WindowsとLinuxのknowledge-vaultをGitで受け渡し、push後の公開処理を始める中央リポジトリとして使用している。

## 関連
- [post-receiveフック](/terms/post-receive-hook/)
