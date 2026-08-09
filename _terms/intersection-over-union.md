---
title: "IoU"
slug: "intersection-over-union"
sort_key: "iou"
summary: "予測した枠と正解の枠がどれくらい重なるかを0から1で表す指標"
category: "ai"
aliases: ["Intersection over Union","交差領域比"]
updated: 2026-08-10
---

## 一言でいうと
予測した枠と正解の枠がどれくらい重なるかを、0から1で表す指標。

## より具体的には
Intersection over Unionの略で、2つの[バウンディングボックス](/terms/bounding-box/)が重なった面積を、両方の枠を合わせた面積で割って求める。まったく重ならなければ0、完全に一致すれば1になる。

[物体検出](/terms/object-detection/)では、予測を正解と対応付ける基準や、[Average Precision（AP）](/terms/average-precision/)を計算するときの条件に使われる。必要なIoUを高くするほど、より正確な位置合わせが求められる。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
変換前後の検出枠の一致確認と、COCOでの品質評価にIoUを使っている。

## 関連
- [バウンディングボックス](/terms/bounding-box/)
- [物体検出](/terms/object-detection/)
- [Average Precision（AP）](/terms/average-precision/)
