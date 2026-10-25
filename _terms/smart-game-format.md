---
title: "SGF（Smart Game Format）"
slug: "smart-game-format"
sort_key: "sgf"
summary: "囲碁などの対局記録や変化図、コメントを保存するテキスト形式"
category: "format"
aliases: ["SGF","Smart Game Format"]
updated: 2026-10-25
---

## 一言でいうと

囲碁などの対局記録や変化図、コメントを保存するテキスト形式。

## より具体的には

着手や対局情報をプロパティとして記述し、木構造で手順や分岐を表す。画像や動画そのものを保存する形式ではなく、棋譜ソフトで読み書きできる対局記録を扱う。

盤面の初期配置も記述できるが、ある局面の石配置だけから、それ以前の着手順や手番が決まるわけではない。対局履歴を出力するには、配置の認識と手順の管理を分けて考える必要がある。

## 関連記事での使用例

### [実盤の囲碁を棋譜に残したい。「碁つづり」を作り始めました](/2026/10/25/gotsuzuri-static-board-recognition.html)

実盤の対局から生成したい棋譜の形式として挙げている。記事時点では、静止画像の石判定までの試作で、SGF出力は未実装。

## 関連

- [Ground Truth](/terms/ground-truth/)

## 参考資料

- [SGF FF[4]公式仕様](https://www.red-bean.com/sgf/)
