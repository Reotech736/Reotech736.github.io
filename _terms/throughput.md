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

### [スマートフォン向け物体検出モデル3候補をPCで比較した](/2026/08/10/smartphone-object-detection-model-comparison.html)
今後の低精度化検証で、処理時間と合わせて1秒間に処理できる画像数を比較する計画を示している。

### [YOLO26のモデル規模・入力解像度による性能差を比較](/2026/08/10/yolo26-scale-resolution-comparison.html)
YOLO26n・640pxとYOLO26s・640pxをFP32、FP16、INT8で比較し、INT8化によって単位時間あたりの処理量が変わるかを実測する計画を示している。

## 関連
- [ONNX Runtime](/terms/onnx-runtime/)
- [モデル量子化](/terms/model-quantization/)
- [入力解像度](/terms/input-resolution/)
