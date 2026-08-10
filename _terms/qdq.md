---
title: "QDQ"
slug: "qdq"
sort_key: "qdq"
summary: "QuantizeLinearとDequantizeLinearを使って量子化境界をgraph上へ明示する表現"
category: "ai"
aliases: ["Quantize-Dequantize","QuantizeLinear / DequantizeLinear","QDQ形式"]
updated: 2026-08-11
---

## 一言でいうと
QuantizeLinearとDequantizeLinearを使い、数値を量子化する場所と元の表現へ戻す場所をgraph上へ明示する形式。

## より具体的には
QuantizeLinearは実数をINT8などの整数表現へ写し、DequantizeLinearは整数表現を後続処理で扱える実数へ戻す。ONNX graphへこの2種類のnodeを配置することで、runtimeは量子化対象と変換境界を判断できる。

QDQ形式でも、graph内のすべての処理が整数演算になるとは限らない。対応していないoperatorや構造処理がFP32のまま残る場合があり、QDQ nodeの追加や整数・実数間の変換も含めた実行性能を確認する必要がある。

## 関連記事での使用例

### [YOLO26n・sのFP32とstatic INT8を比較した](/2026/08/10/yolo26-fp32-static-int8-comparison.html)
ConvとMatMulを量子化したONNX graphを使い、追加されたQDQ nodeとFP32のまま残ったnodeを分けて確認している。

## 関連
- [ONNX](/terms/onnx/)
- [ONNX Runtime](/terms/onnx-runtime/)
- [モデル量子化](/terms/model-quantization/)
- [Static Quantization](/terms/static-quantization/)
