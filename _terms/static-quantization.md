---
title: "Static Quantization"
slug: "static-quantization"
sort_key: "static-quantization"
summary: "代表データを事前に流して推論途中の数値範囲を決める量子化方式"
category: "ai"
aliases: ["静的量子化","Static INT8 Quantization"]
updated: 2026-08-11
---

## 一言でいうと
代表データを事前にモデルへ流し、推論途中の数値を整数へ変換するための範囲を決める量子化方式。

## より具体的には
学習済みモデルの重みだけでなく、activationと呼ばれる推論途中の値もINT8などへ変換するため、事前にcalibration dataを入力して値の範囲を観測する。その結果からscaleやzero pointを決め、量子化済みモデルへ固定する。

モデルを学習し直す方式ではないが、calibration dataの選び方によって量子化後の品質が変わり得る。また、ファイル容量が小さくなっても、実際に高速化するかはhardware、runtime、量子化されずに残る処理などに依存する。

## 関連記事での使用例

### [YOLO26n・sのFP32とstatic INT8を比較した](/2026/08/10/yolo26-fp32-static-int8-comparison.html)
YOLO26nとYOLO26sをQDQ形式のstatic INT8へ変換し、FP32からの品質、PC推論時間、ONNX容量、実行時メモリの変化を比較している。

## 関連
- [モデル量子化](/terms/model-quantization/)
- [量子化キャリブレーション](/terms/quantization-calibration/)
- [QDQ](/terms/qdq/)
- [ONNX Runtime](/terms/onnx-runtime/)
