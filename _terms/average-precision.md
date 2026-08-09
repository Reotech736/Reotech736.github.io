---
title: "Average Precision（AP）"
slug: "average-precision"
sort_key: "average-precision"
summary: "物体検出の見逃しと誤検出のバランスをまとめて表す品質指標"
category: "ai"
aliases: ["Average Precision","AP","AP 50-95"]
updated: 2026-08-10
---

## 一言でいうと
物体検出の見逃しと誤検出のバランスを、1つの値にまとめて表す品質指標。

## より具体的には
モデルが出す確からしさの基準を動かしながら、見つけるべき対象をどれだけ拾えたかと、検出結果のうちどれだけ正しかったかの関係をまとめる。一般に値が大きいほど、見逃しと誤検出のバランスが良い。

AP 50-95は、予測枠と正解枠の重なりを示す[IoU](/terms/intersection-over-union/)について、0.50から0.95まで複数の厳しさで計算したAPを平均する方法である。1つの確からしさの設定だけを見るより、モデル全体の検出品質を比較しやすい。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
COCO val2017全5,000画像のpersonとcarについてAP 50-95を計算し、320pxでの候補選定に使っている。

## 関連
- [物体検出](/terms/object-detection/)
- [IoU](/terms/intersection-over-union/)
- [COCOデータセット](/terms/coco-dataset/)
