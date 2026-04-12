---
title: "head"
slug: "head"
sort_key: "head"
summary: "ファイルや出力の先頭部分だけを表示するコマンド"
category: "shell"
updated: 2026-04-12
---

## 一言でいうと
ファイルや出力の先頭部分だけを表示するコマンド。

## より具体的には
`head` は、テキストの先頭数行だけを素早く確認したいときに使う。  
大きいファイル全体を開かずに、冒頭の構造やサンプルを見たいときに便利。

たとえば次の例では、`docker-compose.yml` の先頭 20 行だけを表示して、設定ファイルの冒頭構造を素早く確認している。

```bash
head -n 20 docker-compose.yml
```

よく使うオプション:
- `-n <行数>`: 表示する行数を指定する
- `-c <バイト数>`: 先頭から指定バイト数だけ表示する
- `-q`: 複数ファイル時の見出しを表示しない

## 関連
- [tail](/terms/tail/)
- [less](/terms/less/)
- [grep](/terms/grep/)
