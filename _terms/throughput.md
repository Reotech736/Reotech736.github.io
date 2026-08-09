---
title: "スループット"
slug: "throughput"
sort_key: "するーぷっと"
summary: "一定時間内に処理できる入力の量"
category: "ai"
aliases: ["Throughput"]
updated: 2026-08-10
---

## 一言でいうと
一定時間内に処理できる入力の量。

## より具体的には
画像推論では、1秒間に処理できる画像数などで表す。1件の処理にかかる時間を示すlatencyとは関連するが、同時実行数、batch size、前処理や後処理を含む範囲によって値が変わる。

比較するときは、単位、batch size、測定区間、入力サイズ、実行環境をそろえる必要がある。カメラアプリでは推論だけのスループットと、撮影・描画まで含めた実効fpsも分けて記録する。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
今後の低精度化検証で、処理時間と合わせて1秒間に処理できる画像数を比較する計画を示している。

## 関連
- [ONNX Runtime](/terms/onnx-runtime/)
- [モデル量子化](/terms/model-quantization/)
- [入力解像度](/terms/input-resolution/)
