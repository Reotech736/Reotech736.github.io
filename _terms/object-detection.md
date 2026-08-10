---
title: "物体検出"
slug: "object-detection"
sort_key: "ぶったいけんしゅつ"
summary: "画像や映像から対象物の種類と位置を見つける技術"
category: "ai"
aliases: ["Object Detection"]
updated: 2026-08-10
---

## 一言でいうと
画像や映像から対象物を見つけ、その種類と位置を示す技術。

## より具体的には
画像を入力すると、「人」「車」などの分類名、見つかった確からしさ、対象を囲む[バウンディングボックス](/terms/bounding-box/)などを出力する。画像全体を一つの種類に分ける画像分類とは異なり、複数の対象がどこにあるかを同時に扱える。

検出品質は、正解の位置との重なりを表す[IoU](/terms/intersection-over-union/)や、見逃しと誤検出をまとめて評価する[Average Precision（AP）](/terms/average-precision/)などで確認する。

## 関連記事での使用例

### [スマートフォン向け物体検出モデル3候補をPCで比較した](/2026/08/10/smartphone-object-detection-model-comparison.html)
スマートフォンのカメラ映像から人と車を見つける候補として、3つのモデルをPC上で比較している。

## 関連
- [バウンディングボックス](/terms/bounding-box/)
- [IoU](/terms/intersection-over-union/)
- [Average Precision（AP）](/terms/average-precision/)
- [COCOデータセット](/terms/coco-dataset/)
