---
title: "モデル量子化"
slug: "model-quantization"
sort_key: "もでるりょうしか"
summary: "AIモデルの数値を少ないbit数で表して小型化や高速化を狙う変換"
category: "ai"
aliases: ["Model Quantization","INT8 Quantization","INT8量子化"]
updated: 2026-08-10
---

## 一言でいうと
AIモデルの数値を少ないbit数で表し、モデルの小型化や推論の高速化を狙う変換。

## より具体的には
学習済みモデルで一般的なFP32の数値を、INT8などの小さな表現へ置き換える。保存容量と計算負荷を減らせる可能性がある一方、元の数値を近似するため、検出品質が下がることがある。

static INT8量子化では、推論途中の値の範囲を決めるためにcalibration dataを使う。品質評価に使うデータとcalibration dataは役割が異なるため、再現できる形で分けて管理する。

FP16は浮動小数点のbit数を減らす低精度変換で、INT8の整数量子化とは仕組みが異なる。FP16やINT8で実際に高速化するかは、CPU、GPU、Execution Providerなどの対応状況に依存する。

## 関連記事での使用例

### [スマートフォン向け物体検出モデルをPCで比較し、実機検証候補を決めた](/2026/08/10/smartphone-object-detection-model-comparison.html)
今後の検証として、選定したYOLO26のモデルと入力解像度を基準に、FP32、FP16、INT8の品質と処理性能を比較する計画を示している。

## 関連
- [ONNX](/terms/onnx/)
- [ONNX Runtime](/terms/onnx-runtime/)
- [Average Precision（AP）](/terms/average-precision/)
- [スループット](/terms/throughput/)
