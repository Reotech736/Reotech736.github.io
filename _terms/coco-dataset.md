---
title: "COCOデータセット"
slug: "coco-dataset"
sort_key: "cocoでーたせっと"
summary: "人や車などの日常的な対象物に正解情報を付けた画像データセット"
category: "ai"
aliases: ["COCO","Common Objects in Context"]
updated: 2026-08-10
---

## 一言でいうと
人や車などの日常的な対象物に、種類や位置の正解情報を付けた画像データセット。

## より具体的には
Common Objects in Contextの略で、[物体検出](/terms/object-detection/)や画像認識の学習・評価に広く使われる。画像ごとに対象物の種類、[バウンディングボックス](/terms/bounding-box/)、領域などのannotationが用意されている。

学習用や検証用などの集合に分かれており、評価では使用した集合、画像数、対象クラス、評価方法をそろえる必要がある。画像ごとの利用条件は、データセットの配布情報と元画像の情報を確認する。

## 関連記事での使用例

### [スマートフォン向け物体検出モデル3候補をPCで比較した](/2026/08/10/smartphone-object-detection-model-comparison.html)
COCO val2017の全5,000画像を共通の品質評価に使い、人と車の検出結果を比較している。

## 関連
- [物体検出](/terms/object-detection/)
- [バウンディングボックス](/terms/bounding-box/)
- [Average Precision（AP）](/terms/average-precision/)
