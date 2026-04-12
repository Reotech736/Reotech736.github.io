---
title: "tail"
slug: "tail"
sort_key: "tail"
summary: "ファイルや出力の末尾部分だけを表示するコマンド"
category: "shell"
updated: 2026-04-12
---

## 一言でいうと
ファイルや出力の末尾部分だけを表示するコマンド。

## より具体的には
`tail` は、ログやテキストの最後の数行だけを確認したいときに使う。  
`-f` と組み合わせると追記を監視できるため、ログ監視で特によく使われる。

たとえば次の例では、`/var/log/nginx/access.log` の末尾を表示しつつ、新しいアクセスログが追記されたらその場で続けて表示している。

```bash
tail -f /var/log/nginx/access.log
```

よく使うオプション:
- `-f`: 追記を監視して表示し続ける
- `-n <行数>`: 末尾から表示する行数を指定する
- `-F`: ファイルの再作成やローテーションにも追従する

## 関連
- [head](/terms/head/)
- [less](/terms/less/)
- [grep](/terms/grep/)
