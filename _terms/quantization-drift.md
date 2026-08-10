---
title: "量子化ドリフト"
slug: "quantization-drift"
sort_key: "りょうしかどりふと"
summary: "量子化前後でモデルの出力や検出結果に生じる差"
category: "ai"
aliases: ["Quantization Drift","quantization drift"]
updated: 2026-08-10
---

## 一言でいうと
モデルを量子化したことで、基準モデルの出力や検出結果から生じる差。

## より具体的には
量子化では連続的な実数を限られた整数へ近似するため、出力値が完全には一致しないことがある。物体検出では、confidence、バウンディングボックスの位置、検出件数、classなどの変化として現れる。

差があること自体だけで採否は決まらない。用途に合わせて品質指標や許容範囲を先に決め、どの検出が両方にあるか、片方だけにあるか、位置や確からしさがどれだけ変わったかを分けて確認する。

## 関連記事での使用例

### [YOLO26n・sのFP32とstatic INT8を比較した](/2026/08/10/yolo26-fp32-static-int8-comparison.html)
confidence 0.4でFP32とINT8の検出を対応付け、matched、FP32-only、INT8-only、class change、無効bboxをモデル別に集計している。

## 関連
- [モデル量子化](/terms/model-quantization/)
- [バウンディングボックス](/terms/bounding-box/)
- [Average Precision（AP）](/terms/average-precision/)
