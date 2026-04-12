---
title: "grep"
slug: "grep"
sort_key: "grep"
summary: "条件に一致する行を検索して抽出するコマンド"
category: "shell"
updated: 2026-04-12
---

## 一言でいうと
条件に一致する行を検索して抽出するコマンド。

## より具体的には
`grep` は、ファイルや標準入力の中から、指定した文字列やパターンに一致する行だけを抜き出す。  
ログ検索や設定ファイル確認の基本になるコマンド。

たとえば次の例では、`application.log` の中から `ERROR` を含む行だけを探し、さらに `-n` で一致した行番号も一緒に表示している。

```bash
grep -n "ERROR" application.log
```

よく使うオプション:
- `-n`: 行番号を表示する
- `-i`: 大文字小文字を無視する
- `-r`: ディレクトリを再帰的に検索する
- `-v`: 一致しない行を表示する

## 関連
- [sed](/terms/sed/)
- [awk](/terms/awk/)
- [less](/terms/less/)
- [tee](/terms/tee/)
