---
title: "バウンディングボックス"
slug: "bounding-box"
sort_key: "ばうんでぃんぐぼっくす"
summary: "画像内の対象物の位置を囲んで示す長方形の枠"
category: "ai"
aliases: ["Bounding Box","bbox"]
updated: 2026-08-10
---

## 一言でいうと
画像内で見つけた対象物の位置を囲んで示す長方形の枠。

## より具体的には
英語のBounding Boxを略してbboxとも呼ぶ。左上と右下の座標、または中心位置と幅・高さなどで表し、[物体検出](/terms/object-detection/)の結果や正解データに使われる。

枠は対象物の輪郭そのものではなく、対象物を収める長方形である。予測した枠と正解の枠がどれくらい重なるかは[IoU](/terms/intersection-over-union/)で比較できる。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
人と車の検出枠だけでなく、枠の下端中央が正解位置からどれくらいずれるかも比較している。

## 関連
- [物体検出](/terms/object-detection/)
- [IoU](/terms/intersection-over-union/)
