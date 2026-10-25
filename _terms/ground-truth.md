---
title: "Ground Truth（GT）"
slug: "ground-truth"
sort_key: "ground-truth"
summary: "学習や評価で正解の基準として使う、観測・確認されたデータ"
category: "ai"
aliases: ["Ground Truth","GT"]
updated: 2026-10-25
---

## 一言でいうと

学習や評価で正解の基準として使う、観測・確認されたデータ。

## より具体的には

画像分類なら対象の種類、物体検出なら位置と種類など、処理が予測する内容に対応した正解を用意する。人が付けたラベルや測定値を使い、予測結果と比べて誤りを調べる。

GTにも入力ミスや判断の曖昧さは含まれ得る。誰が何を基準に確認したかを記録し、モデルの予測を確認せず正解として流用しないことが大切になる。

## 関連記事での使用例

### [実盤の囲碁を棋譜に残したい。「碁つづり」を作り始めました](/2026/10/25/gotsuzuri-static-board-recognition.html)

碁盤の各交点を空・黒・白に分類し、現在の石判定との比較に使っている。同じ配置の写真は同じ撮影グループとして扱う。

## 関連

- [物体検出](/terms/object-detection/)

## 参考資料

- [Google Machine Learning Glossary: ground truth](https://developers.google.com/machine-learning/glossary#ground-truth)
