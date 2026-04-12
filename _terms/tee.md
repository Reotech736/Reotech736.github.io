---
title: "tee"
slug: "tee"
sort_key: "tee"
summary: "標準出力を画面とファイルへ同時に流すコマンド"
category: "shell"
updated: 2026-04-12
---

## 一言でいうと
標準出力を画面とファイルへ同時に流すコマンド。

## より具体的には
`tee` は、パイプで受け取った出力をそのまま画面に表示しながら、同時にファイルへ書き出せる。  
コマンド実行結果を確認しつつログとして保存したいときに便利。

たとえば次の例では、`docker compose logs` の出力を画面に表示しつつ、同じ内容を `compose.log` に保存している。

```bash
docker compose logs | tee compose.log
```

よく使うオプション:
- `-a`: 追記モードで書き込む
- `-i`: 割り込みシグナルを無視する

## 関連
- [grep](/terms/grep/)
- [sed](/terms/sed/)
- [awk](/terms/awk/)
